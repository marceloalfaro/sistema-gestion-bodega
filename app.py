
import os
from dotenv import load_dotenv
from flask import Flask, render_template, request, redirect
import mysql.connector

load_dotenv()

app = Flask(__name__)

db = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME"),
    autocommit=True
)


@app.route("/")
def inicio():
    cursor = db.cursor(dictionary=True)

    # Total productos
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM producto
    """)
    total_productos = cursor.fetchone()["total"]

     # Stock bajo
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM (
            SELECT
                p.id_producto,
                p.stock_minimo,
                COALESCE((
                    SELECT SUM(e.cantidad)
                    FROM entrada e
                    WHERE e.id_producto = p.id_producto
                ), 0)
                -
                COALESCE((
                    SELECT SUM(a.cantidad)
                    FROM asignacion a
                    WHERE a.id_producto = p.id_producto
                ), 0)
                -
                COALESCE((
                    SELECT SUM(m.cantidad)
                    FROM merma m
                    WHERE m.id_producto = p.id_producto
                ), 0) AS stock_actual
            FROM producto p
        ) AS resumen_stock
        WHERE stock_actual <= stock_minimo
    """)

    productos_stock_bajo = cursor.fetchone()["total"]
    
    # Trabajadores activos
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM trabajador
        WHERE activo = TRUE
    """)
    total_trabajadores = cursor.fetchone()["total"]

    # Total de registros de entrada
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM entrada
    """)
    total_entradas = cursor.fetchone()["total"]

    # Asignaciones que todavía no han sido cerradas
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM asignacion
        WHERE fecha_devolucion IS NULL
    """)
    asignaciones_activas = cursor.fetchone()["total"]

    # Cantidad total registrada como merma
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM merma
    """)
    total_mermas = cursor.fetchone()["total"]

    # Últimas 5 entradas
    cursor.execute("""
        SELECT
            e.fecha,
            p.nombre AS producto,
            e.cantidad,
            p.unidad
        FROM entrada e
        JOIN producto p
            ON e.id_producto = p.id_producto
        ORDER BY e.id_entrada DESC
        LIMIT 5
    """)
    ultimas_entradas = cursor.fetchall()

    # Últimas 5 asignaciones
    cursor.execute("""
        SELECT
            t.nombre AS trabajador,
            p.nombre AS producto,
            a.cantidad,
            p.unidad,
            a.fecha_entrega
        FROM asignacion a
        JOIN trabajador t
            ON a.id_trabajador = t.id_trabajador
        JOIN producto p
            ON a.id_producto = p.id_producto
        ORDER BY a.id_asignacion DESC
        LIMIT 5
    """)
    ultimas_asignaciones = cursor.fetchall()

    cursor.close()

    return render_template(
        "index.html",
        total_productos=total_productos,
        total_trabajadores=total_trabajadores,
        total_entradas=total_entradas,
        asignaciones_activas=asignaciones_activas,
        total_mermas=total_mermas,
        ultimas_entradas=ultimas_entradas,
        ultimas_asignaciones=ultimas_asignaciones
    )


@app.route("/productos", methods=["GET", "POST"])
def productos():
    cursor = db.cursor(dictionary=True)

    

    cursor.execute("""
    SELECT
        p.*,

        (
            COALESCE((
                SELECT SUM(e.cantidad)
                FROM entrada e
                WHERE e.id_producto = p.id_producto
            ), 0)

            -

            COALESCE((
                SELECT SUM(a.cantidad)
                FROM asignacion a
                WHERE a.id_producto = p.id_producto
                AND a.fecha_devolucion IS NULL
            ), 0)

            -

            COALESCE((
                SELECT SUM(m.cantidad)
                FROM merma m
                WHERE m.id_producto = p.id_producto
            ), 0)

        ) AS stock

    FROM producto p
    ORDER BY p.nombre
""")



    productos = cursor.fetchall()

    cursor.close()

    return render_template(
        "productos.html",
        productos=productos
    )

@app.route("/proveedores", methods=["GET", "POST"])
def proveedores():
    cursor = db.cursor(dictionary=True)

    if request.method == "POST":
        nombre = request.form["nombre"]
        contacto = request.form["contacto"]

        sql = """
        INSERT INTO proveedor (nombre, contacto)
        VALUES (%s, %s)
        """

        cursor.execute(sql, (nombre, contacto))
        db.commit()
        cursor.close()

        return redirect("/proveedores")

    cursor.execute("SELECT * FROM proveedor")
    proveedores = cursor.fetchall()
    cursor.close()

    return render_template(
        "proveedores.html",
        proveedores=proveedores
    )

@app.route("/entradas", methods=["GET", "POST"])
def entradas():
    cursor = db.cursor(dictionary=True)

    if request.method == "POST":
        fecha = request.form["fecha"]
        id_proveedor = request.form["id_proveedor"]
        id_producto = request.form["id_producto"]
        ndocumento = request.form["ndocumento"]
        cantidad = float(request.form["cantidad"])

        if cantidad <= 0:
            cursor.close()
            return "Error: la cantidad debe ser mayor a 0."

        sql = """
            INSERT INTO entrada
            (fecha, id_proveedor, id_producto, ndocumento, cantidad)
            VALUES (%s, %s, %s, %s, %s)
        """

        cursor.execute(
            sql,
            (fecha, id_proveedor, id_producto, ndocumento, cantidad)
        )

        db.commit()
        cursor.close()

        return redirect("/entradas")

    cursor.execute("SELECT * FROM proveedor")
    proveedores = cursor.fetchall()

    cursor.execute("SELECT * FROM producto")
    productos = cursor.fetchall()

    cursor.execute("""
        SELECT
            e.id_entrada,
            e.fecha,
            pr.nombre AS proveedor,
            p.nombre AS producto,
            e.ndocumento,
            e.cantidad,
            p.unidad
        FROM entrada e
        JOIN proveedor pr
            ON e.id_proveedor = pr.id_proveedor
        JOIN producto p
            ON e.id_producto = p.id_producto
        ORDER BY e.id_entrada DESC
    """)

    entradas = cursor.fetchall()
    cursor.close()

    return render_template(
        "entradas.html",
        proveedores=proveedores,
        productos=productos,
        entradas=entradas
    )
    
@app.route("/trabajadores", methods=["GET", "POST"])
def trabajadores():
    cursor = db.cursor(dictionary=True)

    if request.method == "POST":
        nombre = request.form["nombre"]
        cargo = request.form["cargo"]

        cursor.execute(
            "INSERT INTO trabajador (nombre,cargo) VALUES (%s, %s)",
            (nombre,cargo)
        )

        db.commit()
        cursor.close()

        return redirect("/trabajadores")

    cursor.execute("SELECT * FROM trabajador")
    trabajadores = cursor.fetchall()
    cursor.close()

    return render_template(
        "trabajadores.html",
        trabajadores=trabajadores
    )
@app.route("/asignaciones", methods=["GET", "POST"])
def asignaciones():
    cursor = db.cursor(dictionary=True)

    if request.method == "POST":
        id_trabajador = request.form["id_trabajador"]
        if not id_trabajador:
         cursor.close()
         return redirect("/asignaciones?error=trabajador")

        id_herramienta = request.form.get("id_herramienta")
        id_material = request.form.get("id_material")

        if id_herramienta:
            id_producto = id_herramienta

        elif id_material:
            id_producto = id_material

        else:
            cursor.close()
            return "Debe seleccionar una herramienta o un material"

        cantidad = float(request.form["cantidad"])
        fecha_entrega = request.form["fecha_entrega"]

        # Calcular stock disponible
        cursor.execute("""
            SELECT
                COALESCE((
                    SELECT SUM(e.cantidad)
                    FROM entrada e
                    WHERE e.id_producto = %s
                ), 0) AS total_entrada,

                COALESCE((
                    SELECT SUM(a.cantidad)
                    FROM asignacion a
                    WHERE a.id_producto = %s
                    AND a.fecha_devolucion IS NULL
                ), 0) AS total_asignado,

                COALESCE((
                    SELECT SUM(m.cantidad)
                    FROM merma m
                    WHERE m.id_producto = %s
                ), 0) AS total_merma
        """, (id_producto, id_producto, id_producto))

        datos_stock = cursor.fetchone()

        stock_actual = (
            float(datos_stock["total_entrada"])
            - float(datos_stock["total_asignado"])
            - float(datos_stock["total_merma"])
        )

        if cantidad <= 0:
            cursor.close()
            return "Error: la cantidad debe ser mayor a 0."

        if cantidad > stock_actual:
            cursor.close()
            return redirect(
        f"/asignaciones?error=stock&disponible={stock_actual:g}&solicitado={cantidad:g}"
    )

        sql = """
            INSERT INTO asignacion
            (id_trabajador, id_producto, cantidad, fecha_entrega)
            VALUES (%s, %s, %s, %s)
        """

        cursor.execute(
            sql,
            (id_trabajador, id_producto, cantidad, fecha_entrega)
        )

        db.commit()
        cursor.close()

        return redirect("/asignaciones")

    cursor.execute("""
        SELECT *
        FROM trabajador
        WHERE activo = TRUE
    """)

    trabajadores = cursor.fetchall()

    cursor.execute("""
        SELECT *
        FROM producto
        ORDER BY nombre
    """)

    productos = cursor.fetchall()

    cursor.execute("""
        SELECT
            a.id_asignacion,
            t.id_trabajador,
            p.nombre AS producto,
            p.categoria_uso,
            a.cantidad,
            p.unidad,
            a.fecha_entrega,
            a.fecha_devolucion,
            a.estado
        FROM asignacion a
        JOIN trabajador t
            ON a.id_trabajador = t.id_trabajador
        JOIN producto p
            ON a.id_producto = p.id_producto
        ORDER BY a.id_asignacion DESC
    """)

    asignaciones = cursor.fetchall()

    cursor.close()

    return render_template(
        "asignaciones.html",
        trabajadores=trabajadores,
        productos=productos,
        asignaciones=asignaciones
        ,
    error=request.args.get("error"),
    disponible=request.args.get("disponible"),
    solicitado=request.args.get("solicitado")
    )
@app.route("/mermas", methods=["GET", "POST"])
def mermas():
    cursor = db.cursor(dictionary=True)

    error = None

    if request.method == "POST":
        id_producto = request.form["id_producto"]
        cantidad = float(request.form["cantidad"])
        motivo = request.form["motivo"]
        fecha = request.form["fecha"]
        observacion = request.form["observacion"]

        # Calcular stock disponible
        cursor.execute("""
            SELECT
                COALESCE((
                    SELECT SUM(e.cantidad)
                    FROM entrada e
                    WHERE e.id_producto = %s
                ), 0) AS total_entrada,

                COALESCE((
                    SELECT SUM(a.cantidad)
                    FROM asignacion a
                    WHERE a.id_producto = %s
                ), 0) AS total_asignado,

                COALESCE((
                    SELECT SUM(m.cantidad)
                    FROM merma m
                    WHERE m.id_producto = %s
                ), 0) AS total_merma
        """, (id_producto, id_producto, id_producto))

        datos_stock = cursor.fetchone()

        stock_actual = (
            float(datos_stock["total_entrada"])
            - float(datos_stock["total_asignado"])
            - float(datos_stock["total_merma"])
        )

        # Validaciones
        if cantidad <= 0:
            error = "La cantidad debe ser mayor a 0."

        elif cantidad > stock_actual:
            error = "La cantidad de merma supera el stock disponible."

        # Registrar solamente si no hay errores
        if error is None:

            sql = """
                INSERT INTO merma
                (id_producto, cantidad, motivo, fecha, observacion)
                VALUES (%s, %s, %s, %s, %s)
            """

            cursor.execute(
                sql,
                (id_producto, cantidad, motivo, fecha, observacion)
            )

            db.commit()
            cursor.close()

            return redirect("/mermas")

    # Obtener productos con stock disponible
    cursor.execute("""
        SELECT
            p.id_producto,
            p.nombre,
            p.unidad,

            (
                COALESCE((
                    SELECT SUM(e.cantidad)
                    FROM entrada e
                    WHERE e.id_producto = p.id_producto
                ), 0)

                -

                COALESCE((
                    SELECT SUM(a.cantidad)
                    FROM asignacion a
                    WHERE a.id_producto = p.id_producto
                ), 0)

                -

                COALESCE((
                    SELECT SUM(m.cantidad)
                    FROM merma m
                    WHERE m.id_producto = p.id_producto
                ), 0)

            ) AS stock_actual

        FROM producto p

        HAVING stock_actual > 0

        ORDER BY p.nombre
    """)

    productos = cursor.fetchall()

    # Obtener mermas registradas
    cursor.execute("""
        SELECT
            m.id_merma,
            p.nombre AS producto,
            m.cantidad,
            p.unidad,
            m.motivo,
            m.fecha,
            m.observacion
        FROM merma m
        JOIN producto p
            ON m.id_producto = p.id_producto
        ORDER BY m.id_merma DESC
    """)

    mermas = cursor.fetchall()

    cursor.close()

    return render_template(
        "mermas.html",
        productos=productos,
        mermas=mermas,
        error=error
    )
@app.route("/informes")
def informes():
    cursor = db.cursor(dictionary=True)

    trabajador_id = request.args.get("trabajador")
    tipo = request.args.get("tipo")

    # =========================
    # SELECTOR DE TRABAJADORES
    # =========================

    cursor.execute("""
        SELECT id_trabajador, nombre
        FROM trabajador
        WHERE activo = 1
        ORDER BY nombre
    """)
    trabajadores = cursor.fetchall()

    # =========================
    # SELECTOR DE TIPOS
    # =========================

    cursor.execute("""
        SELECT DISTINCT tipo
        FROM producto
        WHERE tipo IS NOT NULL
        ORDER BY tipo
    """)
    tipos = cursor.fetchall()

    # =========================
    # INFORME POR TRABAJADOR
    # =========================

    sql_trabajador = """
        SELECT
            t.nombre AS trabajador,
            p.nombre AS producto,
            p.tipo,
            a.cantidad,
            p.unidad,
            a.fecha_entrega,
            a.fecha_devolucion
        FROM asignacion a
        JOIN trabajador t
            ON a.id_trabajador = t.id_trabajador
        JOIN producto p
            ON a.id_producto = p.id_producto
        WHERE 1 = 1
    """

    valores = []

    if trabajador_id:
        sql_trabajador += """
            AND t.id_trabajador = %s
        """
        valores.append(trabajador_id)

    if tipo:
        sql_trabajador += """
            AND p.tipo = %s
        """
        valores.append(tipo)

    sql_trabajador += """
        ORDER BY t.nombre, a.fecha_entrega DESC
    """

    cursor.execute(sql_trabajador, valores)
    informe_trabajador = cursor.fetchall()

    # =========================
    # INFORME POR TIPO
    # =========================

    sql_tipo = """
        SELECT
            p.tipo,
            p.nombre AS producto,
            SUM(e.cantidad) AS total_ingresado,
            p.unidad
        FROM entrada e
        JOIN producto p
            ON e.id_producto = p.id_producto
        WHERE 1 = 1
    """

    valores_tipo = []

    if tipo:
        sql_tipo += """
            AND p.tipo = %s
        """
        valores_tipo.append(tipo)

    sql_tipo += """
        GROUP BY
            p.tipo,
            p.id_producto,
            p.nombre,
            p.unidad
        ORDER BY p.tipo, p.nombre
    """

    cursor.execute(sql_tipo, valores_tipo)
    informe_tipo = cursor.fetchall()

    # =========================
    # STOCK ACTUAL
    # =========================

    cursor.execute("""
        SELECT
            p.id_producto,
            p.nombre AS producto,
            p.tipo,
            p.unidad,

            COALESCE((
                SELECT SUM(e.cantidad)
                FROM entrada e
                WHERE e.id_producto = p.id_producto
            ), 0) AS total_entrada,

            COALESCE((
                SELECT SUM(a.cantidad)
                FROM asignacion a
                WHERE a.id_producto = p.id_producto
            ), 0) AS total_asignado,

            COALESCE((
                SELECT SUM(m.cantidad)
                FROM merma m
                WHERE m.id_producto = p.id_producto
            ), 0) AS total_merma

        FROM producto p
        ORDER BY p.nombre
    """)

    stock = cursor.fetchall()

    for item in stock:
        item["stock_actual"] = (
            item["total_entrada"]
            - item["total_asignado"]
            - item["total_merma"]
        )

    cursor.close()

    return render_template(
        "informes.html",
        informe_trabajador=informe_trabajador,
        informe_tipo=informe_tipo,
        stock=stock,
        trabajadores=trabajadores,
        tipos=tipos,
        trabajador_seleccionado=trabajador_id,
        tipo_seleccionado=tipo
    )
@app.route("/asignaciones/<int:id_asignacion>/cerrar", methods=["POST"])
def cerrar_asignacion(id_asignacion):
    cursor = db.cursor()

    estado = request.form["estado"]
    fecha_devolucion = request.form["fecha_devolucion"]

    sql = """
        UPDATE asignacion
        SET estado = %s,
            fecha_devolucion = %s
        WHERE id_asignacion = %s
    """

    cursor.execute(
        sql,
        (estado, fecha_devolucion, id_asignacion)
    )

    db.commit()
    cursor.close()

    return redirect("/asignaciones")

@app.route("/asignaciones/<int:id_asignacion>/eliminar", methods=["POST"])
def eliminar_asignacion(id_asignacion):
    cursor = db.cursor()

    cursor.execute(
        "DELETE FROM asignacion WHERE id_asignacion = %s",
        (id_asignacion,)
    )

    db.commit()
    cursor.close()

    return redirect("/asignaciones")



if __name__ == "__main__":
    app.run(debug=True)
    