<!--- LISTA DE TRANSACCIONES EN PROCESO DE SER REVISADAS Y PROCESADAS DE LA TABLA GATTRANSACCIONES, PROCESO GESTION DE AF --->
<!--- Consultas Comunes para varias pantallas. --->
<cfinclude template="Transacciones-encab.cfm">
<!--- PINTA EL FORM DEL FILTRO --->
<form action="Transacciones.cfm" method="post" name="lista" style="margin:0">
	<!--- Pinta campos ocultos con información de las consultas --->
	<cfoutput>
	<input name="GATPeriodo" type="hidden" value="#form.GATPeriodo#">
	<input name="GATMes" type="hidden" value="#form.GATMes#">
	<input name="Cconcepto" type="hidden" value="#form.Cconcepto#">
	<input name="Edocumento" type="hidden" value="#form.Edocumento#">
	</cfoutput>
	<!--- NAVEGACION PARA LOS FILTROS ADICIONALES --->
	<cfset navegacion = "">
	<cfset navegacion = navegacion
		& "&GATPeriodo=#Form.GATPeriodo#&GATMes=#Form.GATMes#&Cconcepto=#Form.Cconcepto#&Edocumento=#Form.Edocumento#">
	<!--- PINTA LISTA CON FILTROS POR COLUMNA --->
	<!--- Query para filtro por estado --->
	<cfparam name="form.Filtro_Estados" default="-1">
	<cfset rsEstados = QueryNew("value,description")>
	<cfset QueryAddRow(rsEstados,1)>
	<cfset QuerySetCell(rsEstados, "value", -1, rsEstados.recordcount)>
	<cfset QuerySetCell(rsEstados, "description", "--Todos--", rsEstados.recordcount)>
	<cfset QueryAddRow(rsEstados,1)>
	<cfset QuerySetCell(rsEstados, "value", 0, rsEstados.recordcount)>
	<cfset QuerySetCell(rsEstados, "description", "Incompleto", rsEstados.recordcount)>
	<cfset QueryAddRow(rsEstados,1)>
	<cfset QuerySetCell(rsEstados, "value", 1, rsEstados.recordcount)>
	<cfset QuerySetCell(rsEstados, "description", "Completo", rsEstados.recordcount)>
	<cfset QueryAddRow(rsEstados,1)>
	<cfset QuerySetCell(rsEstados, "value", 2, rsEstados.recordcount)>
	<cfset QuerySetCell(rsEstados, "description", "Conciliado", rsEstados.recordcount)>
	<cfset QueryAddRow(rsEstados,1)>
	<cfset QuerySetCell(rsEstados, "value", 3, rsEstados.recordcount)>
	<cfset QuerySetCell(rsEstados, "description", "Aplicado", rsEstados.recordcount)>
	<!--- 	Parámetro para filtrar por estas columnas en lugar de como lo haría por defecto que sería por "desplegar". 
			Se Connstruye por aparte porque dentro de las columnas por las que se necesita filtrar van algunas con "comas",
			esto no se puede pasar en una lista separada por comnas como la lista corriente "filtrar_por", entonces se pasa
			por este parámetro que acepta un arreglo. Para efectos de agilizar la creación del arreglo se crea con una lista
			separada por "|".
	--->
	<cfset arr_filtrar_por_array = ListToArray("a.GATplaca|a.GATdescripcion|b.CFformato|coalesce(a.GATmonto,0.00)|a.GATestado","|")>
	<!--- Invocación al Componente de Listas --->
	<cf_dbfunction name="spart" args="a.GATdescripcion,1,35" returnvariable="Descripcion">
	<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="rspLista"
	
		columnas=" a.ID as GATid, coalesce(a.GATplaca,'-') as Placa, 
				#Descripcion# as Descripcion, 
				b.CFformato, c.CFdescripcion as CFuncional, coalesce(GATmonto,0.00) as GATmonto, 
				case a.GATestado
				when 0 then 'Incompleto'
				when 1 then 'Completo'
				when 2 then 'Conciliado'
				when 3 then 'Aplicado'
				end as Estado"
		tabla="GATransacciones a
				left outer join CFinanciera b
					on b.CFcuenta = a.CFcuenta
					and b.Ecodigo = a.Ecodigo
				left outer join CFuncional c
					on c.CFid = a.CFid 
					and c.Ecodigo = a.Ecodigo"
		filtro="	a.Ecodigo = #Session.Ecodigo#
					and GATperiodo = #Form.GATPeriodo#
					and GATmes = #Form.GATMes#
					and Cconcepto = #Form.Cconcepto#
					and Edocumento = #Form.Edocumento#
					order by ID"	
		desplegar="Placa, Descripcion, CFformato, GATmonto, Estado"
		etiquetas="Placa, Descripcion, Cuenta, Monto, Estado"
		totales="GATmonto"
		totalgenerales="GATmonto"
		filtrar_por_array="#arr_filtrar_por_array#"
		formatos="S,S,S,M,S"
		align="left,left,left,right,center"
		
		mostrar_filtro="true"
		filtrar_automatico="true"
		
		rsEstado="#rsEstados#"
		
		MaxRows="25"
		irA="Transacciones.cfm"
		
		showLink = "true"
		
		ajustar="N"
				
		incluyeform="false"
		formname="lista"
		
		navegacion="#navegacion#"		
		
		keys="GATid"
		
		debug="N"
		
	/>
	<cfquery name="rsEstadoGAT" datasource="#session.dsn#">
		select min(GATestado) as GATestado from GATransacciones
			where Ecodigo = #session.Ecodigo#
			and Cconcepto = #form.Cconcepto#
			and Edocumento = #form.Edocumento#
			and GATperiodo = #form.GATPeriodo#
			and GATmes = #form.GATMes#
	</cfquery>
	<cfif rsEstadoGAT.GATestado EQ 0 or rsEstadoGAT.GATestado EQ 1>
	<cf_botones values="Nuevo, Ir a Conciliar, Lista, Eliminar" names="btnNuevo, btnConciliar, btnLista, btnEliminar" tabindex="1">
	<cfelse>
	<cf_botones values="Nuevo, Ir a Conciliar, Lista" names="btnNuevo, btnConciliar, btnLista" tabindex="1">
	</cfif>
</form>
<cfoutput>
<script language="javascript" type="text/javascript">
	<!--//
		function funcbtnConciliar(){
			document.location.href="Conciliacion.cfm?GATPeriodo=#Form.GATPeriodo#&GATmes=#Form.GATMes#&Cconcepto=#Form.Cconcepto#&Edocumento=#Form.Edocumento#";
			return false;
		}
		function funcbtnEliminar(){
			if ( confirm('¿Desea Eliminar el Registro?') )
			{
				document.lista.action = 'Transacciones-sql.cfm';
				document.lista.botonSel.value = 'BajaTodos';
				document.lista.botonSel.name = 'BajaTodos';
				return true;
			}
			else 
			{
				//document.lista.action = 'Transacciones.cfm';
				//document.lista.botonSel.value = '';
				//document.lista.botonSel.name = 'botonSel';
				return false;
			}
		}
	//-->
</script>
</cfoutput>