<!---==================TRADUCCION===================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Debe_seleccionar_al_menos_un_expediente_antes_de_Aplicar"
	Default="Debe seleccionar al menos un expediente antes de Aplicar"	
	returnvariable="MSG_Debe_seleccionar_al_menos_un_expediente_antes_de_Aplicar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Expediente"
	Default="Expediente"	
	returnvariable="LB_Expediente"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre_Completo"
	Default="Nombre Completo"	
	returnvariable="LB_Nombre_Completo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha"
	Default="Fecha"	
	returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_hay_expedientes_pendientes_para_Aplicar"
	Default="No hay expedientes pendientes para Aplicar"	
	returnvariable="MSG_No_hay_expedientes_pendientes_para_Aplicar"/>


<script language="javascript" type="text/javascript">
	function funcAplicar() {
		<cfoutput>
		if (document.listaExpedientes.chk) {
			if (document.listaExpedientes.chk.value) {
				if (!document.listaExpedientes.chk.checked)
					alert('#MSG_Debe_seleccionar_al_menos_un_expediente_antes_de_Aplicar#');
				return (document.listaExpedientes.chk.checked);
			} else {
				for (var i=0; i<document.listaExpedientes.chk.length; i++) {
					if (document.listaExpedientes.chk[i].checked) return true;
				}
				alert('#MSG_Debe_seleccionar_al_menos_un_expediente_antes_de_Aplicar#');
			}
		}
		</cfoutput>
		return false;
	}
	
</script>

<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
  	<td>&nbsp;</td>
  </tr>
  <tr>
    <td>

		<cfquery name="rsLista" datasource="#session.DSN#">
			select a.IEid, 
				   a.EFEid, 
				   a.TEid, 
				   a.DEid,
				   {fn concat(b.TEdescripcion,{fn concat(': ',c.EFEdescripcion)})} as Expediente,
				   {fn concat({fn concat({fn concat({ fn concat(d.DEnombre, ' ') },d.DEapellido1)}, ' ')},d.DEapellido2) } as Nombre,
				   a.IEfecha as Fecha
 			from IncidenciasExpediente a
			
			inner join TipoExpediente b
		     on a.TEid = b.TEid			
			 
			inner join EFormatosExpediente c
			  on a.EFEid = c.EFEid			 
			  
			inner join DatosEmpleado d			  
			  on a.DEid = d.DEid
			
			where a.IEestado = 0
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  
			order by a.IEfecha desc
		</cfquery>


	<!---	<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="Expediente, Nombre, Fecha"/>
			<cfinvokeargument name="etiquetas" value="#LB_Expediente#, #LB_Nombre_Completo#, #LB_Fecha#"/>
			<cfinvokeargument name="formatos" value="V,V,D"/>
			<cfinvokeargument name="align" value="left, left, center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="botones" value="Aplicar,Nuevo"/>
			<cfinvokeargument name="irA" value="/cfmx/rh/expedientemng/save.cfm"/>
			<cfinvokeargument name="keys" value="IEid"/>
			<cfinvokeargument name="MaxRows" value="0"/>
			<cfinvokeargument name="formName" value="listaExpedientes"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="EmptyListMsg" value="--- #MSG_No_hay_expedientes_pendientes_para_Aplicar# ---"/>
		</cfinvoke>--->
		<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="IncidenciasExpediente a			
																						inner join TipoExpediente b
																					     on a.TEid = b.TEid																								 
																						inner join EFormatosExpediente c
																						  on a.EFEid = c.EFEid																						  
																						inner join DatosEmpleado d			  
																						  on a.DEid = d.DEid"/>
			<cfinvokeargument name="columnas" value="a.IEid, 
				   a.EFEid, 
				   a.TEid, 
				   a.DEid,
				   b.TEdescripcion#_CAT#': '#_CAT#c.EFEdescripcion as Expediente,
				  d.DEnombre#_CAT#' '#_CAT#d.DEapellido1#_CAT#' '#_CAT#d.DEapellido1 as Nombre,
				   a.IEfecha as Fecha"/>
			<cfinvokeargument name="desplegar" value="Expediente, Nombre, Fecha"/>
			<cfinvokeargument name="etiquetas" value="#LB_Expediente#, #LB_Nombre_Completo#, #LB_Fecha#"/>
			<cfinvokeargument name="formatos" value="V,V,D"/>
			<cfinvokeargument name="filtro" value="a.IEestado = 0 and a.Ecodigo =#Session.Ecodigo# order by a.IEfecha desc"/>
			<cfinvokeargument name="align" value="left, left, center"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="botones" value="Aplicar,Nuevo"/>
			<cfinvokeargument name="irA" value="/cfmx/rh/expedientemng/save.cfm"/>
			<cfinvokeargument name="keys" value="IEid"/>
			<cfinvokeargument name="MaxRows" value="0"/>
			<cfinvokeargument name="formName" value="listaExpedientes"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="EmptyListMsg" value="--- #MSG_No_hay_expedientes_pendientes_para_Aplicar# ---"/>
			<cfinvokeargument name="mostrar_filtro" value="yes"/>					
			<cfinvokeargument name="mostrar_filtro" value="yes"/>
			<cfinvokeargument name="filtrar_automatico" value="yes"/>
			<cfinvokeargument name="filtrar_por" value=" b.TEdescripcion#_CAT#': '#_CAT#c.EFEdescripcion, d.DEnombre#_CAT#' '#_CAT#d.DEapellido1#_CAT#' '#_CAT#d.DEapellido1, Fecha">
		</cfinvoke>
	</td>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>

<script>
	function funcNuevo(){
		document.listaExpedientes.action = '/cfmx/rh/expedientemng/Expediente.cfm';
	}
</script>


