<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Todos"
	Default="Todos"
	returnvariable="LB_Todos"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SinAtender"
	Default="Sin Atender"
	returnvariable="LB_SinAtender"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Atendidos"
	Default="Atendidos"
	returnvariable="LB_Atendidos"/>

<cfset checked = "<img src=/cfmx/rh/imagenes/checked.gif border=0>">
<cfset unchecked = "<img src=/cfmx/rh/imagenes/unchecked.gif border=0>">

<cffunction name="fixParam" access="private">
<cfargument name="p" required="true">
<cfif (isdefined("url.#Arguments.p#") and len(trim(Evaluate("url.#Arguments.p#"))) GT 0)>
	<cfset Evaluate("form.#Arguments.p#=url.#Arguments.p#")>
	<cfset Evaluate("form.H#Arguments.p#=url.#Arguments.p#")>
</cfif>
</cffunction>

<cfset fixParam("filtro_atendido")>

<cfparam name="form.filtro_atendido" default="0">

<cfset rsAtendido = QueryNew("value,description","integer,varchar")>
<cfset QueryAddRow(rsAtendido,3)>
<cfset QuerySetCell(rsAtendido,"value","-1",1)>
<cfset QuerySetCell(rsAtendido,"description"," -- "&#LB_Todos#& " -- ",1)>
<cfset QuerySetCell(rsAtendido,"value","0",2)>
<cfset QuerySetCell(rsAtendido,"description",#LB_SinAtender#,2)>
<cfset QuerySetCell(rsAtendido,"value","1",3)>
<cfset QuerySetCell(rsAtendido,"description",#LB_Atendidos#,3)>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_IdentificacionEmpleado"
	Default="Identificaci&oacute;n Empleado"
	returnvariable="LB_IdentificacionEmpleado"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NombreEmpleado"
	Default="Nombre Empleado"
	returnvariable="LB_NombreEmpleado"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaEntrega"
	Default="Fecha Entrega"
	returnvariable="LB_FechaEntrega"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Atendido"
	Default="Atendido"
	returnvariable="LB_Atendido"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoHayRegistrosParaSuConsulta"
	Default="No hay registros para su consulta"
	returnvariable="MSG_NoHayRegistrosParaSuConsulta"/>


	<cfset ValuesArray = ArrayNew(1)>
	<cfset ArrayAppend(ValuesArray, "b.DEidentificacion")>
	<cfset ArrayAppend(ValuesArray, "{fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre )}")>
	<cfset ArrayAppend(ValuesArray, "a.CSEfrecoge")>
	<cfset ArrayAppend(ValuesArray, "a.CSEatendida")>
	
	<cfinvoke component="rh.Componentes.pListas" 
			method="pListaRH" 
			returnvariable="Lista" 
			columnas="a.CSEid, a.CSEfrecoge, 
					b.DEid, b.DEidentificacion, {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )}, ' ' )}, b.DEnombre )} as Nombre ,
					c.EFid, {fn concat({fn concat(rtrim(c.EFcodigo) , '  ' )},  c.EFdescripcion )}  as EFcoddes,
					case a.CSEatendida when 0 then '#unchecked#' else '#checked#' end as atendido"
			tabla="CertificacionesEmpleado a
					left outer join DatosEmpleado b
						on b.DEid = a.DEid
					inner join EFormato c
						on c.EFid = a.EFid"
			filtro="a.Ecodigo = #Session.Ecodigo#
					order by c.EFid, a.CSEfrecoge"
			desplegar="DEidentificacion,Nombre,CSEfrecoge,atendido"
			etiquetas="#LB_IdentificacionEmpleado#,#LB_NombreEmpleado#,#LB_FechaEntrega#,#LB_Atendido#"
			cortes="EFcoddes"
			filtrar_por_array="#ValuesArray#"
			formatos="S,S,D,S"
			align="left,left,center,left"
			ajustar="S"
			mostrar_filtro="true"
			filtrar_automatico="true"
			showemptylistmsg="true"
			maxrows="15"
			ira="generarFormato-sql.cfm"
			botones="Nuevo,Generar"
			showlink="false"
			radios="N"
			checkboxes="S"
			keys="CSEid"
			rsAtendido="#rsAtendido#"
			/> 

	
	<script language="javascript" type="text/javascript">
		<!--//
			function funcNuevo(){
				document.lista.action = "generarFormato.cfm";
			}
			function funcGenerar(){
				if (marcado()&&confirmado()) return true;
				return false;
			}
			function marcado(){
				if (document.lista.chk) {
					if (document.lista.chk.value) {
						return true;
					} else {
						for (var i=0; i<document.lista.chk.length; i++) {
							if (document.lista.chk[i].checked) { 
								return true;
							}
						}
					}
				}
				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_DebeMmarcarAlMenosUnDocumentoParaProcesarloDesdeEstaSeccionSiDeseaCrearUnoNuevoUtiliceElBotonDeNuevo"
					Default="Debe marcar al menos un documento para procesarlo desde esta sección, si desea crear uno nuevo, utilice el botón de nuevo."
					returnvariable="MSG_DebeMmarcarAlMenosUnDocumentoParaProcesarloDesdeEstaSeccionSiDeseaCrearUnoNuevoUtiliceElBotonDeNuevo"/>
				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_ConfimaQueDeseaGenerarLaCertificacionMarcada"
					Default="Confima que Desea Generar la certificación marcada"
					returnvariable="MSG_ConfimaQueDeseaGenerarLaCertificacionMarcada"/>
				
				alert("<cfoutput>#MSG_DebeMmarcarAlMenosUnDocumentoParaProcesarloDesdeEstaSeccionSiDeseaCrearUnoNuevoUtiliceElBotonDeNuevo#</cfoutput>");
				return false;
			}
			function confirmado(){
				return confirm("<cfoutput>#MSG_ConfimaQueDeseaGenerarLaCertificacionMarcada#</cfoutput>?");
			}
		//-->
	</script>