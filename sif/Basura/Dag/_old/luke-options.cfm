	<cfset Menues = QueryNew("Name, Description, Link, Category, SubCategory")>
	<!--- SET 1 --->
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Home",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Consola de Administración de Cuentas por Cobrar.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/Basura/Dag/luke.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Home",Menues.RecordCount)>

	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Facturas",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","El proceso de registro de facturas, comprende la inclusión de las cuentas por cobrar de la empresa dentro del módulo. Se incluirán las características asociadas al documento como los son: número de documento, fecha, oficina, cuenta contable asociada, tipo de transacción (factura o nota débito), moneda, retención al pagar, impuesto, clientes y lista de clientes existentes, tipo de cambio, descuento. Adicionalmente el portal, calcula el valor de impuesto y total de cada factura.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/operacion/RegistroFacturas.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Facturas",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Notas de Crédito",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","El proceso de ingreso de Notas de Crédito, comprende la inclusión de los documentos a favor de los clientes dentro del módulo. Se incluirán las características asociadas al documento como los son: Documento, fecha de creación, Cuenta Contable asociada, oficina, tipo de transacción, moneda, Retención al pagar clientes, Impuesto, y el documento de referencia o factura asociada, lista de clientes existentes, tipo de cambio y descuento.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/operacion/RegistroNotasCredito.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Notas de Crédito",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Pagos",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Permite ingresar pagos realizados por un cliente a las cuentas por cobrar o facturas. El registro de pagos puede realizarse para múltiples facturas pendientes, pagando facturas de forma total o parcial en múltiples monedas, es decir, la moneda de pago pude ser distinta a la moneda de la factura. Debido a que existe la posibilidad de que el pago sea mayor a los documentos que se van a aplicar, el sistema tiene la opción de generar un anticipo de dinero con la cantidad sobrante del pago, el cual puede ser utilizado posteriormente como un documento a favor para ser aplicado a otro documento de débito. ",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/operacion/ListaPagos.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Pagos",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Aplicación",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","La aplicación del documento implica el registro de la nota de crédito para los documentos seleccionados, esto con base en la definición de montos realizada por documento. Al momento de realizar la aplicación de la nota de crédito se generan referencias a la nota de crédito por medio del cual fue cancelado de forma parcial o total el documento. Además se genera la afectación contable. ",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/operacion/listaDocsAfavorCC.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Aplicación",Menues.RecordCount)>

	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Otras Operaciones",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Operaciones Adicionales de Cuentas por Cobrar.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Otras Operaciones",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Clientes Detallistas",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Registro y aprobación de solicitudes de clientes de detalle, especialmente aquéllos que requieran obtener crédito.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/catalogos/clientes/Clientes.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Otras Operaciones",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Planes de Pago",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Registro de Planes de Pago  para las Facturas de Crédito cuyo pago se vaya a financiar en varias cuotas.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/operacion/plan_pagos/index.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Otras Operaciones",Menues.RecordCount)>
		
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Neteo Documentos",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Este Proceso permite saldar documentos de CXC con documentos de CXP y viceversa, si requerir que la suma de los saldos de los documentos de cxc sea igual a la de los documentos de cxp. Por la diferencia se generará un dnuvo documento. Este Proceso es compartido entre CXP y CXC.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/operacion/Neteo.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Otras Operaciones",Menues.RecordCount)>

	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Eliminación Saldos",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Este Proceso permite saldar documentos de CXC con con Montos que se decidan despreciar.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/operacion/Saldos.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Otras Operaciones",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Eliminación Gen. Doc.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Este Proceso permite saldar documentos de CXC con documentos de CXP y viceversa, si requerir que la suma de los saldos de los documentos de cxc sea igual a la de los documentos de cxp. Por la diferencia se generará un dnuvo documento. Este Proceso es compartido entre CXP y CXC.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/operacion/Neteo2.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Otras Operaciones",Menues.RecordCount)>
		
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Intereses Moratorios",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Este Proceso permite calcular en forma masiva los intereses moratorios para los documentos de CxC con saldos y vencidos a una fecha en particular.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/operacion/RegistroInteresMoratorioCxC.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Otras Operaciones",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Reclamos",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Registro de Reclamos para los Documentos de Cuentas por Cobrar.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/operacion/RegReclamoCC.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Otras Operaciones",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Catálogos",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Catálogos de Cuentas por Cobrar.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Catálogos",Menues.RecordCount)>

	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Clasificación Socios",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/ad/catalogos/SNClasificaciones.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Catálogos",Menues.RecordCount)>

	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Estado Socios",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/catalogos/EstadoSNegocios.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Catálogos",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Grupos Socios",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/catalogos/GrupoSocios.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Catálogos",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Socios Negocios",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/ad/catalogos/listaSocios.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Catálogos",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Conceptos Fact.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/ad/catalogos/Conceptos.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Catálogos",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Retenciones",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/ad/catalogos/Retenciones.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Catálogos",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Transacciones CxC",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/catalogos/TipoTransacciones.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Catálogos",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Rol de Empleado",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/catalogos/RolEmpleadoCxC.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Catálogos",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Consultas",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Consultas de Cuentas por Cobrar.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Consultas",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Estado de Cuenta",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/consultas/EstadoCuenta.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Consultas",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Historico x Socio",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/consultas/RFacturasCC.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Consultas",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Historico x Doc.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/consultas/RFacturasCC2.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Consultas",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Análisis Antigüedad",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/admin/Consultas/AntigSaldosCxC.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Consultas",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Reportes",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","Reportes de Cuentas por Cobrar.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Reportes",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Socios x Clas.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/reportes/SociosxClasificacion.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Reportes",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Saldos Clasificación",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/reportes/SaldosxClasificacion.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Reportes",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Saldos sin Aplicar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/reportes/SaldosFavorSinAplicar.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Reportes",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Morosidad",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/reportes/Morosidad.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Reportes",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Análisis Cliente",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/reportes/AnalisisCliente.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Reportes",Menues.RecordCount)>
	
	<cfset QueryAddRow(Menues,1)>
	<cfset QuerySetCell(Menues,"Name","Antigüedad x Clas.",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Description","",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Link","/cfmx/sif/cc/reportes/AntiguedadSaldosClasificacion.cfm",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"Category","Cuentas por Cobrar",Menues.RecordCount)>
	<cfset QuerySetCell(Menues,"SubCategory","Reportes",Menues.RecordCount)>