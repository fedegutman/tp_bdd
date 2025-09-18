import pandas as pd
from faker import Faker
import random

fake = Faker("es_ES")

# Cantidades de datos
N_ESTUDIANTES = 10
N_PROFESORES = 5
N_GRUPOS = 3
N_MATERIAS = 7   # más materias de las que enseñan
N_CLASES = 10
N_PAGOS = 10

# ------------------ USUARIOS ------------------
usuarios = []
id_counter = 1
emails_usados = {}  # para controlar duplicados

def generar_email(nombre, apellido):
    base = f"{nombre.lower()}.{apellido.lower()}"
    if base not in emails_usados:
        emails_usados[base] = 1
        return f"{base}@gmail.com"
    else:
        emails_usados[base] += 1
        return f"{base}.{emails_usados[base]}@gmail.com"

# Estudiantes
ids_estudiantes = []
for _ in range(N_ESTUDIANTES):
    nombre = fake.first_name()
    apellido = fake.last_name()
    email = generar_email(nombre, apellido)

    usuarios.append({
        "id_usuario": id_counter,
        "dni": fake.unique.random_int(10000000, 99999999),
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "contraseña": fake.password()
    })
    ids_estudiantes.append(id_counter)
    id_counter += 1

# Profesores
ids_profesores = []
for _ in range(N_PROFESORES):
    nombre = fake.first_name()
    apellido = fake.last_name()
    email = generar_email(nombre, apellido)

    usuarios.append({
        "id_usuario": id_counter,
        "dni": fake.unique.random_int(10000000, 99999999),
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "contraseña": fake.password()
    })
    ids_profesores.append(id_counter)
    id_counter += 1

df_usuarios = pd.DataFrame(usuarios)
df_usuarios.to_csv("usuarios.csv", index=False)

# ------------------ ESTUDIANTES ------------------
estudiantes = []
for id_e in ids_estudiantes:
    estudiantes.append({
        "id_estudiante": id_e,
        "nivel_academico": random.choice(["Primario", "Secundario", "Universitario"]),
        "edad": random.randint(10, 30)
    })
df_estudiantes = pd.DataFrame(estudiantes)
df_estudiantes.to_csv("estudiante.csv", index=False)

# ------------------ PROFESORES ------------------
profesores = []
for id_p in ids_profesores:
    profesores.append({
        "id_profesor": id_p,
        "telefono": fake.unique.random_int(1000000000, 1999999999),
        "años_experiencia": random.randint(1, 20),
        "tarifa": random.randint(1000, 5000)
    })
df_profesores = pd.DataFrame(profesores)
df_profesores.to_csv("profesor.csv", index=False)

# ------------------ GRUPOS ------------------
grupos = []
for i in range(1, N_GRUPOS + 1):
    grupos.append({"id_grupo": i, "nombre": f"Grupo {i}"})
df_grupos = pd.DataFrame(grupos)
df_grupos.to_csv("grupo.csv", index=False)

# ------------------ estudiantePerteneceGrupo ------------------
est_grupo = []
grupos_ids = [g["id_grupo"] for g in grupos]

estudiantes_disponibles = ids_estudiantes.copy()
random.shuffle(estudiantes_disponibles)

for gid in grupos_ids:
    if estudiantes_disponibles:
        e = estudiantes_disponibles.pop()
        est_grupo.append({
            "id_estudiante": e,
            "id_grupo": gid
        })

for e in estudiantes_disponibles:
    if random.random() < 0.5:
        est_grupo.append({
            "id_estudiante": e,
            "id_grupo": random.choice(grupos_ids)
        })

df_est_grupo = pd.DataFrame(est_grupo)
df_est_grupo.to_csv("estudiantePerteneceGrupo.csv", index=False)


# ------------------ MATERIAS ------------------
materias_lista = [
    "Matemáticas", "Lengua", "Historia", "Geografía", "Física", "Química",
    "Biología", "Inglés", "Arte", "Música", "Tecnología", "Politica","Economía","Programación"
]

materias = []
for i in range(1, N_MATERIAS + 1):
    materias.append({
        "id_materia": i,
        "nombre": random.choice(materias_lista),
        "nivel": random.choice(["Basico", "Intermedio", "Avanzado"])
    })

df_materias = pd.DataFrame(materias)
df_materias.to_csv("materia.csv", index=False)

# ------------------ profesorEnseñaMateria ------------------
prof_materia = []
materias_ids = [m["id_materia"] for m in materias]

for p in ids_profesores:
    # Cada profesor enseña al menos una materia
    n_materias = random.choices(
        [1, 2, 3,4],       # puede enseñar 1, 2 o 3 materias
        weights=[0.5, 0.30, 0.1,0.1],  # mayor probabilidad de 1 sola
        k=1
    )[0]

    materias_asignadas = random.sample(materias_ids, n_materias)
    for m in materias_asignadas:
        prof_materia.append({
            "id_profesor": p,
            "id_materia": m
        })

df_prof_materia = pd.DataFrame(prof_materia)
df_prof_materia.to_csv("profesorEnseñaMateria.csv", index=False)


# ------------------ DISPONIBILIDAD ------------------
dias = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes"]
disponibilidad = []

from datetime import datetime, timedelta

# ------------------ DISPONIBILIDAD COMPLETA ------------------
dias = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes"]
disponibilidad = []

hora_inicio_dia = datetime.strptime("08:00:00", "%H:%M:%S")
hora_fin_dia = datetime.strptime("20:00:00", "%H:%M:%S")
bloque_duracion = timedelta(hours=2)
incremento = timedelta(minutes=30)  # para permitir 08:30, 09:30, etc.

for d in dias:
    hora_actual = hora_inicio_dia
    while hora_actual + bloque_duracion <= hora_fin_dia:
        inicio_hora = hora_actual.strftime("%H:%M:%S")
        fin_hora = (hora_actual + bloque_duracion).strftime("%H:%M:%S")
        disponibilidad.append({
            "dia_semana": d,
            "horario_inicio": inicio_hora,
            "horario_fin": fin_hora
        })
        hora_actual += incremento

df_disponibilidad = pd.DataFrame(disponibilidad)
df_disponibilidad.to_csv("disponibilidad.csv", index=False)


# ------------------ profesorTieneDisponibilidad ------------------
prof_disp = []
for p in ids_profesores:
    # Cada profesor tiene entre 2 y 4 disponibilidades distintas
    n_disp = random.randint(2, 4)
    disponibilidades_asignadas = random.sample(disponibilidad, n_disp)

    for d in disponibilidades_asignadas:
        prof_disp.append({
            "id_profesor": p,
            "dia_semana": d["dia_semana"],
            "horario_inicio": d["horario_inicio"],
            "horario_fin": d["horario_fin"]
        })

df_prof_disp = pd.DataFrame(prof_disp)
df_prof_disp.to_csv("profesorTieneDisponibilidad.csv", index=False)

# ------------------ CLASES (con pago embebido) ------------------
clases = []
dias_semana = {
    "Lunes": 0,
    "Martes": 1,
    "Miercoles": 2,
    "Jueves": 3,
    "Viernes": 4
}

for i in range(1, N_CLASES + 1):
    prof = random.choice(profesores)
    # buscar disponibilidades de ese profesor
    disp_prof = [d for d in prof_disp if d["id_profesor"] == prof["id_profesor"]]
    
    if not disp_prof:
        continue  # profesor sin disponibilidad, salteamos
    
    d = random.choice(disp_prof)
    dia_nombre = d["dia_semana"]
    hora_inicio = d["horario_inicio"]

    # Generar fecha válida que caiga en el día correcto
    fecha_random = fake.date_time_this_year()
    while fecha_random.weekday() != dias_semana[dia_nombre]:
        fecha_random = fake.date_time_this_year()
    
    # Ajustar hora
    fecha_random = fecha_random.replace(hour=int(str(hora_inicio).split(":")[0]), minute=0, second=0)

    duracion = random.choice([1.0, 1.5, 2.0])
    monto = round(prof["tarifa"] * duracion, 2)

    clases.append({
        "id_clase": i,
        "duracion_en_horas": duracion,
        "fecha_y_hora": fecha_random,
        "modalidad": random.choice(["Online", "Presencial"]),
        "estado": random.choice(["Pendiente", "Confirmada", "Finalizada"]),
        "id_profesor": prof["id_profesor"],

        # ---- Datos de pago embebidos ----
        "numero_recibo": fake.unique.uuid4()[:8],
        "metodo": random.choice(["Efectivo", "Tarjeta", "Transferencia"]),
        "estado_pago": random.choice(["Pendiente", "Pagado"]),
        "monto": monto
    })

df_clases = pd.DataFrame(clases)
df_clases.to_csv("clase.csv", index=False)

# ------------------ INSCRIPCIONES ------------------
inscripciones = []
for clase in clases:
    n_estudiantes = random.choices(
        [1, 2, 3, 4, 5],  # posibles cantidades
        weights=[0.5, 0.3, 0.1, 0.07, 0.03],  # probabilidades
        k=1
    )[0]

    n_estudiantes = min(n_estudiantes, len(ids_estudiantes))

    estudiantes_clase = random.sample(ids_estudiantes, n_estudiantes)
    for e in estudiantes_clase:
        inscripciones.append({
            "id_estudiante": e,
            "id_clase": clase["id_clase"]
        })

df_inscripciones = pd.DataFrame(inscripciones)
df_inscripciones.to_csv("inscripcion.csv", index=False)


# ------------------ RESEÑAS ------------------
resenas = []
ya_reseñado = set()
for e in ids_estudiantes:
    if random.random() < 0.4:  # no todos reseñan
        p = random.choice(ids_profesores)
        if (e, p) not in ya_reseñado:
            ya_reseñado.add((e, p))
            resenas.append({
                "id_estudiante": e,
                "id_profesor": p,
                "puntaje": random.randint(1, 5),
                "comentario": fake.sentence(nb_words=10),
                "fecha": fake.date_time_this_year()
            })
df_resenas = pd.DataFrame(resenas)
df_resenas.to_csv("reseña.csv", index=False)

print("✅ CSVs generados con reglas correctas")


print("✅ CSVs generados correctamente con dependencias consistentes")
