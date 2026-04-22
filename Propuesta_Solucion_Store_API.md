# Habilitación de Vales como medio de pago — Tienda FULL (en línea)

**Documento:** Propuesta de solución y alineación técnica (Store API)  
**Audiencia:** Dirección / Producto / TI  
**Versión:** 1.0

---

## Resumen ejecutivo

Tienda FULL requiere **aceptar Vales (vouchers) como método de pago en su canal en línea**. La propuesta contempla una **API REST** orientada a la tienda (`WS/crc/Store.cfc`) para **validar** y **reservar** folios (bloqueo del instrumento en canal web), un **GET de planes de pago** calculados según **monto** a partir de la **base de datos LD**, una especificación **OpenAPI** y la **integración** con los componentes de compra y folios digitales del ecosistema CRC. **Queda explícitamente fuera de este alcance el consumo definitivo del folio:** ese paso ocurre cuando se **procese la venta en la sucursal correspondiente**, no en la Store API. El paquete de trabajo prioriza **seguridad de la API**, **validación y firma de solicitudes**, **lógica de reserva en base de datos** precisa y transaccional, y **contrato API documentado y probado**. Por el riesgo inherente a **pagos y folios sensibles**, la propuesta se plantea como **un único entregable robusto** (sin variante mínima).

---

## Objetivo de negocio

| Elemento | Descripción |
|----------|-------------|
| **Qué** | Permitir al cliente usar **Vales** al pagar en la **tienda en línea** de Tienda FULL y **consultar planes de pago** aplicables al **monto** del carrito u operación. |
| **Para qué** | Ampliar medios de pago, alinear canal web con reglas de negocio de vouchers y mejorar conversión en checkout. |
| **Criterio de éxito** | En canal en línea: validación del vale, **reserva** del folio acorde a reglas, respuestas claras al front y trazabilidad ante errores o fraude. El **consumo** del vale queda atado al **procesamiento de la venta en sucursal**. |
| **Límite de alcance (API / tienda)** | Este paquete contempla solo la **reserva de folios** en el flujo web. **No** incluye la lógica de **consumo** del folio, que se ejecutará **al procesar la venta en la sucursal correspondiente**. |

---

## Alcance técnico (síntesis)

- **API de tienda** con endpoints de **validación** y **checkout/reserva** de folio (reservado para la operación web), **consulta de planes de pago** vía **GET** (origen de datos: **BD LD**, criterio principal **monto**), artefacto **OpenAPI** (`store-openapi-spec.yaml`). El **consumo** del instrumento **no** forma parte de este entregable: corresponde al **circuito de venta en sucursal** una vez registrada o liquidada la operación allí.
- **Integración** con el dominio de compra y **Vales** (`Vales.cfc`, `CRCCompras`, `CRCChequearProducto`, entre otros).
- **Requisitos a cubrir** en diseño y construcción:
  - Firma y validación de payload **acordes a prácticas de APIs de pago**.
  - Reserva de folio por **identificador exacto** (evitar coincidencias parciales y vectores SQL).
  - Estados de folio y transacciones en **validaVale()** **definidos y consistentes**.
  - OpenAPI **como contrato único** frente al servicio (esquemas, errores y ejemplos cerrados), incluido el **GET de planes de pago**.
  - Consulta a **LD** para planes: manejo de **monto** inválido o sin planes aplicables con respuestas explícitas.

*(Detalle por archivo al final como referencia para equipos de implementación.)*

---

## Propuesta (enfoque)

1. **API robusta:** validación de JSON, canonizado explícito para firma, HTTP semánticos (400/401/500) y rechazo de variantes no soportadas.
2. **Planes de pago (GET):** exponer un endpoint **GET** que reciba el **monto** (p. ej. query `monto`), consulte la **base de datos LD** y devuelva la **lista de planes de pago posibles** para ese importe (mismas reglas de autenticación / firma que el resto de la Store API, según diseño acordado). Documentar respuesta y errores en OpenAPI.
3. **Reserva de folios (solo reservado):** actualización por **coincidencia exacta** de número de vale, verificación previa de existencia, manejo de “ya reservado” y, donde aplique, **transacción o bloqueo** en BD. La **liquidación / consumo** del folio queda **fuera** de esta capa y se realiza **al procesar la venta en la sucursal correspondiente**.
4. **Dominio:** revisión de flujo digital vs. físico (`digital`, `obCuentaVale()`, campos faltantes) para evitar tratamientos cruzados.
5. **Contrato y calidad:** cerrar OpenAPI (autenticación, firma, ejemplos y errores) y **pruebas** (validación, checkout, **planes por monto**, autorización, HMAC, duplicados).

---

## Endpoint: planes de pago (borrador de contrato)

| Aspecto | Definición |
|---------|------------|
| **Método y propósito** | **GET** — obtener los **planes de pago disponibles** para un **monto** dado. |
| **Origen de datos** | **Base de datos LD** (consultas y reglas de elegibilidad según tablas/vistas acordadas con negocio). |
| **Parámetros** | **Monto** del pedido u operación (p. ej. query `monto`, numérico; moneda y redondeo según estándar del canal). Parámetros adicionales solo si LD o negocio lo exigen (documentar en OpenAPI). |
| **Respuesta** | Colección de **planes de pago posibles** (estructura de ítem: identificador de plan, cuotas o plazo, importes relevantes, etiquetas para UI — **definición final en esquema OpenAPI**). |
| **Errores** | Entre otros: monto inválido (**400**), no hay planes para el monto (**200** con lista vacía o **404**/código de negocio — **definir criterio único**), fallo de datos (**502**/500 según política). |
| **Seguridad** | Alineada al resto de la Store API (autenticación / firma según diseño ya definido para el canal). |

*La ruta exacta (p. ej. `/payment-plans` vs. `/planes-pago`) y el nombre del query string se fijan al cerrar el contrato OpenAPI y la convención de rutas del proyecto.*

---

## Inversión estimada

**Tarifa referencia:** 800 / hora

| Paquete | Alcance | Horas | Costo estimado |
|---------|---------|-------|----------------|
| **Propuesta robusta** | Auditoría de seguridad, firma y validaciones, **GET planes de pago** (BD **LD**, por **monto**), **reserva de folios** (SQL y reglas de folio en web), OpenAPI cerrada, pruebas e integración, QA y despliegue. **Sin** desarrollo del **consumo** en sucursal. | **21 h** | **16,800** |

### Desglose del trabajo

| Actividad | Horas | Entregable / notas |
|-----------|------:|--------------------|
| Revisión y **auditoría de seguridad** de la capa Store (autenticación, firma, superficie de ataque) | **2** | Informe breve y criterios de cierre |
| **API robusta:** validación de JSON, canonizado de firma, códigos HTTP coherentes, rechazo de variantes no soportadas | **5** | Comportamiento estable en `Store.cfc` (o equivalente) |
| **Planes de pago (GET):** acceso a **BD LD**, filtrado / reglas por **monto**, armado de respuesta (lista de planes aplicables), manejo de vacíos y validación de parámetros | **3** | Endpoint operativo + criterios de negocio acordados con LD |
| **Reserva de folios:** consultas por identificador exacto, estados de folio, concurrencia / transacción donde aplique, alineación con **validaVale()** | **4** | Reserva web consistente; **sin** consumo en sucursal |
| **Dominio CRC:** integración con Vales / compras (digital vs. físico, campos obligatorios, `obCuentaVale()`) | **3** | Flujo checkout web alineado a reglas de negocio |
| **OpenAPI:** esquemas, errores, ejemplos, contrato alineado al servicio (**incluye GET planes de pago**) | **2** | `store-openapi-spec.yaml` cerrado para integradores |
| **Pruebas, integración en staging y cierre:** casos UAT acordados, ajustes finales, handover | **2** | Evidencia de pruebas y lista de pendientes (si las hay) |
| **Total** | **21** | |

*Las horas son estimación de trabajo efectivo; el orden puede solaparse según disponibilidad del equipo y del ambiente de staging.*

---

## Próximos pasos sugeridos

1. Aprobación del **presupuesto y alcance** del paquete robusto y ventana de **staging**.  
2. Priorizar **diseño de reserva** y **validación de la API** como primer entregable bloqueante.  
3. Cierre de **contrato OpenAPI** en paralelo con el front de Tienda FULL en línea.  
4. **UAT** con casos: vale válido, inválido, ya reservado, firma incorrecta, llamada no autorizada; **planes de pago** con montos con planes, sin planes y límites de negocio. Validar que la reserva en web **coexiste** con el hecho de que el **consumo** se prueba en el flujo de **venta en sucursal** (fuera de este alcance).

---

## Referencia técnica (módulos previstos)

| Área | Archivos principales |
|------|----------------------|
| API Store | `WS/crc/Store.cfc`, `WS/crc/store-openapi-spec.yaml` |
| Datos planes (LD) | Conexión / consultas a **BD LD** (tablas o vistas según especificación de negocio; detalle de DSN o capa de acceso por definir en implementación) |
| Compra / vouchers | `crc/Componentes/compra/CRCChequearProducto.cfc`, `crc/Componentes/compra/CRCCompras.cfc`, `crc/Componentes/web/Vales.cfc` |
| Operación crédito | `crc/credito/operacion/VerificarProducto_sql.cfm` (presentación en flujo de verificación, si aplica) |

---

## Conclusión

Habilitar **Vales** en la **tienda en línea de Tienda FULL** es viable con una **Store API** integrada al dominio CRC y un contrato OpenAPI explícito, con **reservado de folios** en el canal web y **consulta de planes de pago** desde **LD** según **monto**. El **consumo** del vale al cerrar el ciclo comercial corresponde al **procesamiento de la venta en la sucursal correspondiente** y **no** se incluye aquí. El **go-live seguro** de esta capa exige **endurecimiento de seguridad**, **reserva de folios correcta en BD** y **pruebas** acordes al riesgo del flujo; este documento describe **esa única línea de trabajo** para equilibrar **riesgo operativo, fraude y experiencia de cliente** en el alcance definido.
