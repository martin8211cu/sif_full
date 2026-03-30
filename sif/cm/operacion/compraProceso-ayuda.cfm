<div class="ayuda">
	<cfif Session.Compras.ProcesoCompra.Pantalla EQ "0">
		<strong>Procesos de Compra:</strong><br><br>
		Seleccione el proceso de compra que desea modificar. Este lo llevar&aacute; al 
		<font color="#003399"><strong>Paso 1</strong></font>.<br><br>
		Para eliminar procesos de compra ya creados, seleccione los que desea eliminar y haga click en el bot&oacute;n de <font color="#003399"><strong>Eliminar</strong></font>.<br><br>
	<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "1">
		<strong>Paso 1:</strong><br><br>
		Seleccione los &iacute;temes de compra que desea incluir en este proceso de compra.
		Cuando haya terminado haga click en el bot&oacute;n de  
		<font color="#003399"><strong>Guardar y Continuar >></strong></font> para continuar al siguiente paso.<br><br>
		Tambi&eacute;n puede utilizar el cuadro de <font color="#003399"><strong>Pasos</strong></font> para saltar a las dem&aacute;s opciones pero ning&uacute;n cambio es guardado utilizando esta v&iacute;a.<br><br>
	<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "2">
		<cfif not isdefined("Form.btnNotas")>
			<strong>Paso 2:</strong><br><br>
			Llene el formulario con los datos requeridos para el proceso de compra.<br><br>
			Puede seleccionar un grupo de criterios predefinidos para el proceso de compra y modificar los pesos si desea. La suma de los pesos debe ser <font color="#003399"><strong>100</strong></font>.<br><br>
			Cuando haya terminado haga click en el bot&oacute;n de  
			<font color="#003399"><strong>Guardar y Continuar >></strong></font> para continuar al siguiente paso.<br><br>
			Tambi&eacute;n puede utilizar el cuadro de <font color="#003399"><strong>Pasos</strong></font> para saltar a las dem&aacute;s opciones pero ning&uacute;n cambio es guardado utilizando esta v&iacute;a.<br><br>
		<cfelse>
			<strong>Notas:</strong><br><br>
			Llene el formulario con los datos requeridos para el proceso de compra.<br><br>
			Para regresar al Proceso de Compra haga click en el bot&oacute;n de   
			<font color="#003399"><strong>Regresar</strong></font>.<br><br>
		</cfif>
	<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "3">
		<strong>Paso 3:</strong><br><br>
		Indique si desea invitar a todos los proveedores o si desea invitar &uacute;nicamente a algunos de ellos.<br><br>
		Cuando haya terminado haga click en el bot&oacute;n de  
		<font color="#003399"><strong>Guardar y Continuar >></strong></font> para continuar al siguiente paso.<br><br>
		Tambi&eacute;n puede utilizar el cuadro de <font color="#003399"><strong>Pasos</strong></font> para saltar a las dem&aacute;s opciones pero ning&uacute;n cambio es guardado utilizando esta v&iacute;a.<br><br>
	<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "4">
		<strong>Paso 4:</strong><br><br>
		Verifique que los datos mostrados para el proceso de compra sean correctos.<br><br>
		Cuando haya terminado haga click en el bot&oacute;n de  
		<font color="#003399"><strong>Publicar</strong></font>.<br><br>
		 Si requiere realizar alguna correcci&oacute;n, puede utilizar el cuadro de <font color="#003399"><strong>Pasos</strong></font> para saltar a los pasos anteriores.<br><br>
	<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "5">
		<strong>Paso 5:</strong><br><br>
		Registre mediante esta opción manualmente nuevas cotizaciones.<br><br>
		Estas cotizaciones no son automáticamente aplicadas, esto quiere decir que usted puede realizar cambios en sus cotizaciones sin que estos sean definitivos hasta que aplique el documento, 
		para poner la cotización en firme presione el botón 
		<font color="#003399"><strong>Aplicar</strong></font>.<br><br>
		 Si requiere realizar alguna correcci&oacute;n, puede utilizar el cuadro de <font color="#003399"><strong>Pasos</strong></font> para saltar a los pasos anteriores.<br><br>
	<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "6">
		<strong>Paso 6:</strong><br><br>
		La siguiente lista muestra las cotizaciones hechas para este proceso de compra.<br><br>
		Las cotizaciones hechas por los proveedores deben ser importadas para observarlas en esta opción,
		para importar las cotizaciones de los proveedores presione el botón
		<font color="#003399"><strong>Importar</strong></font>.<br><br>
		 Si requiere realizar alguna correcci&oacute;n, puede utilizar el cuadro de <font color="#003399"><strong>Pasos</strong></font> para saltar a los pasos anteriores.<br><br>
	</cfif>
</div>
