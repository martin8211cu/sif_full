<cfset Menues = QueryNew("Name,Description,Category,Link")>
<!--- SET 1 --->
<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Registro de Facturas",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","El proceso de registro de facturas, comprende la inclusi&oacute;n de las cuentas por cobrar de la empresa dentro del m&oacute;dulo. Se incluir&aacute;n las caracter&iacute;sticas asociadas al documento como los son: n&uacute;mero de documento, fecha, oficina, cuenta contable asociada, tipo de transacci&oacute;n (factura o nota d&eacute;bito), moneda, retenci&oacute;n al pagar, impuesto, clientes y lista de clientes existentes, tipo de cambio, descuento. Adicionalmente el portal, calcula el valor de impuesto y total de cada factura.",Menues.RecordCount)>

<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Registro de Notas de Cr&eacute;dito",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","El proceso de ingreso de Notas de Cr&eacute;dito, comprende la inclusi&oacute;n de los documentos a favor de los clientes dentro del m&oacute;dulo. Se incluir&aacute;n las caracter&iacute;sticas asociadas al documento como los son: Documento, fecha de creaci&oacute;n, Cuenta Contable asociada, oficina, tipo de transacci&oacute;n, moneda, Retenci&oacute;n al pagar clientes, Impuesto, y el documento de referencia o factura asociada, lista de clientes existentes, tipo de cambio y descuento.",Menues.RecordCount)>

<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Registro de Pagos",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","Permite ingresar pagos realizados por un cliente a las cuentas por cobrar o facturas. El registro de pagos puede realizarse para m&uacute;ltiples facturas pendientes, pagando facturas de forma total o parcial en m&uacute;ltiples monedas, es decir, la moneda de pago pude ser distinta a la moneda de la factura. Debido a que existe la posibilidad de que el pago sea mayor a los documentos que se van a aplicar, el sistema tiene la opci&oacute;n de generar un anticipo de dinero con la cantidad sobrante del pago, el cual puede ser utilizado posteriormente como un documento a favor para ser aplicado a otro documento de d&eacute;bito. ",Menues.RecordCount)>

<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Aplicaci&oacute;n de Documentos a Favor",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","La aplicaci&oacute;n del documento implica el registro de la nota de cr&eacute;dito para los documentos seleccionados, esto con base en la definici&oacute;n de montos realizada por documento. Al momento de realizar la aplicaci&oacute;n de la nota de cr&eacute;dito se generan referencias a la nota de cr&eacute;dito por medio del cual fue cancelado de forma parcial o total el documento. Adem&aacute;s se genera la afectaci&oacute;n contable. ",Menues.RecordCount)>

<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Neteo de Documentos",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","Este Proceso permite saldar documentos de CXC con documentos de CXP y viceversa. Este Proceso es compartido entre CXP y CXC.Este Proceso permite saldar documentos de CXC con documentos de CXP y viceversa. Este Proceso es compartido entre CXP y CXC.",Menues.RecordCount)>

<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Eliminaci&oacute;n de Saldos Despreciables",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","Este Proceso permite saldar documentos de CXC con con Montos que se decidan despreciar.",Menues.RecordCount)>

<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Neteo Generando Nuevo Documento",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","Este Proceso permite saldar documentos de CXC con documentos de CXP y viceversa, si requerir que la suma de los saldos de los documentos de cxc sea igual a la de los documentos de cxp. Por la diferencia se generará un dnuvo documento. Este Proceso es compartido entre CXP y CXC.",Menues.RecordCount)>

<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Neteo de Documentos",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","Este Proceso permite saldar documentos de CXC con documentos de CXP y viceversa. Este Proceso es compartido entre CXP y CXC.Este Proceso permite saldar documentos de CXC con documentos de CXP y viceversa. Este Proceso es compartido entre CXP y CXC.",Menues.RecordCount)>

<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Registro de Intereses Moratorios",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","Este Proceso permite calcular en forma masiva los intereses moratorios para los documentos de CxC con saldos y vencidos a una fecha en particular.",Menues.RecordCount)>

<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Registro de Reclamos",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","Registro de Reclamos para los Documentos de Cuentas por Cobrar.",Menues.RecordCount)>

<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Neteo de Documentos",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","Este Proceso permite saldar documentos de CXC con documentos de CXP y viceversa. Este Proceso es compartido entre CXP y CXC.Este Proceso permite saldar documentos de CXC con documentos de CXP y viceversa. Este Proceso es compartido entre CXP y CXC.",Menues.RecordCount)>
