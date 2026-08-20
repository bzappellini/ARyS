# Trabajo Práctico 1 — Conceptos de Seguridad

> ARyS · IF046 · UNPSJB Trelew. Modalidad: análisis + laboratorio ligero + informe.
> Duración estimada: una clase práctica (3 h) + entrega.

## Objetivos

1. Aplicar el vocabulario de la unidad (CIA, activo, amenaza, vulnerabilidad,
   riesgo, control) a un caso real.
2. **Ver funcionar** cada pilar de la tríada CIA con herramientas de línea de
   comandos disponibles en cualquier GNU/Linux.
3. Redactar un mini análisis de riesgo y proponer controles justificados.

> Todo el laboratorio se hace sobre **archivos y máquinas propias**. No se accede
> a datos ni sistemas de terceros.

---

## Parte A — El inventario y la tríada (individual)

Elegí un sistema real y acotado que conozcas: tu notebook, el servidor de un
laboratorio, la PC de tu trabajo.

1. **Listá cinco activos** de ese sistema (no solo hardware: pensá en datos,
   servicios, credenciales, reputación).
2. Para cada activo, indicá **cuál pilar de CIA es el más crítico** y por qué.
   Ejemplo: "la base de datos de alumnos → **integridad** y **confidencialidad**;
   que se caiga una hora (disponibilidad) es tolerable, que se filtre o se
   altere, no".
3. Para el activo más importante, identificá **una amenaza**, **una
   vulnerabilidad** que esa amenaza podría explotar, y estimá el **riesgo**
   (impacto Alto/Medio/Bajo × probabilidad Alta/Media/Baja).

**Entregable A:** tabla de activos con su pilar CIA crítico, y el mini análisis
de riesgo del activo principal.

---

## Parte B — La tríada en acción (laboratorio)

Trabajá en una terminal GNU/Linux (o una VM). Cada ejercicio ilustra **un pilar**.

### B.1 Integridad — funciones de hash

```bash
# Creamos un archivo y calculamos su huella (hash SHA-256)
echo "Transferir 1000 a la cuenta 55" > orden.txt
sha256sum orden.txt

# Alteramos UN carácter y volvemos a calcular
echo "Transferir 9000 a la cuenta 55" > orden.txt
sha256sum orden.txt
```

**Consigna B.1.** Compará los dos hashes. ¿Cuánto cambió el resultado al cambiar
un solo dígito? Explicá con tus palabras cómo un hash permite **detectar** una
violación de integridad, y por qué no sirve para *deshacerla*.

### B.2 Confidencialidad — cifrado simétrico

```bash
# Ciframos el archivo con una contraseña (GnuPG, cifrado simétrico)
gpg -c orden.txt          # genera orden.txt.gpg

# Sin la contraseña, el contenido es ilegible
cat orden.txt.gpg         # basura binaria

# Con la contraseña, se recupera
gpg -d orden.txt.gpg
```

**Consigna B.2.** Mostrá que `orden.txt.gpg` es ilegible sin la clave. ¿Qué pilar
protege el cifrado? Si alguien **roba el archivo cifrado pero no la contraseña**,
¿se violó la confidencialidad? ¿Y si además borra tu única copia?

### B.3 Confidencialidad e integridad — control de acceso

```bash
# Permisos actuales
ls -l orden.txt

# Restringimos el acceso: solo el dueño puede leer y escribir
chmod 600 orden.txt
ls -l orden.txt           # -rw-------
```

**Consigna B.3.** Explicá qué significa `600` y cómo el **control de acceso** del
sistema de archivos aporta a la confidencialidad y a la integridad. Relacionalo
con el principio de **menor privilegio**.

### B.4 Disponibilidad — el backup que se prueba

```bash
# Simulamos un backup y una restauración
cp orden.txt orden.bak
rm orden.txt              # "perdimos" el original
cp orden.bak orden.txt    # restauramos
cat orden.txt
```

**Consigna B.4.** ¿Qué pilar protege el backup? Explicá por qué un backup **que
nunca se restauró** no cuenta como control efectivo (relacionalo con la regla
"3-2-1" que veremos en la Unidad 2).

**Entregable B:** capturas de las cuatro pruebas y las respuestas a cada consigna.

---

## Parte C — Del riesgo al control (individual)

Retomá el activo principal de la Parte A.

1. Elegí **dos controles** que reduzcan el riesgo identificado.
2. Para cada uno, indicá su **tipo** (preventivo / detectivo / correctivo /
   disuasivo) y a **qué pilar** de CIA protege.
3. Justificá cuál implementarías **primero** si solo pudieras aplicar uno, y por
   qué (pensá en costo vs. reducción de riesgo).

**Entregable C:** tabla de controles propuestos + párrafo de justificación.

---

## Entrega y evaluación

- **Formato:** un único PDF con las partes A, B y C. Nombre: `TP1_ApellidoNombre.pdf`.
- **Vía:** campus virtual UNPSJB.
- **Criterios de corrección:**
  - Uso correcto del vocabulario (activo, amenaza, vulnerabilidad, riesgo) (25 %).
  - Ejecución y comprensión de los ejercicios B.1–B.4 (35 %).
  - Coherencia del análisis de riesgo y de los controles propuestos (30 %).
  - Claridad y prolijidad del informe (10 %).

## Para investigar (opcional, suma)

- Diferencia entre **cifrado** y **hash**: ¿por qué uno es reversible y el otro no?
- Qué es una **colisión** de hash y por qué MD5 y SHA-1 se consideran inseguros.
- Cómo se relaciona el principio de **menor privilegio** con los permisos de Unix
  (usuario / grupo / otros).
