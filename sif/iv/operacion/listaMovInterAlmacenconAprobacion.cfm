<cfquery name="rsLista" datasource="#session.DSN#">
	select a.EMdoc,a.EMid, a.EMalm_Orig, a.EMalm_Dest, a.EMfecha, b.Bdescripcion as AlmOri, 
	c.Bdescripcion as AlmDest
	from EMinteralmacen a
    	inner join AResponsables d
      	 on a.EMalm_Orig = d.Aid
       	and d.Usucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_integer" >  
	  inner join Almacen b
	  on a.EMalm_Orig = b.Aid 
	  inner join Almacen c 
	  on a.EMalm_Dest = c.Aid
	where a.Ecodigo = #session.Ecodigo#
    and Eestado = 1
    and a.Ecodigo =  d.Ecodigo 	
</cfquery>
<script language="JavaScript1.2" type="text/javascript">
	function existe(form, name){
	// RESULTADO
	// Valida la existencia de un objecto en el form
	
		if (form[name] != undefined) {
			return true
		}
		else{
			return false
		}
	}

	function check_all(obj){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (obj.checked){
				if (form.chk.length){
					for (var i=0; i<form.chk.length; i++){
						form.chk[i].checked = "checked";
					}
				}
				else{
					form.chk.checked = "checked";
				}
			}	
		}
	}
</script>
<cf_templateheader title="Inventarios">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Movimientos InterAlmac&eacute;n con Aprobaci&oacute;n'>
			<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
				<tr> 
					<td width="1%"><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
					<td valign="middle"><b>Seleccionar Todo</b></td>
				</tr>	
				<tr>
				  	<td colspan="2">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
						 <cfinvokeargument name="query" 				value="#rsLista#"/>
							<cfinvokeargument name="desplegar" 			value="EMdoc,AlmOri,AlmDest,EMfecha"/>
							<cfinvokeargument name="etiquetas" 			value="Documento, Almacén Origen, Almac&eacute;n Destino, Fecha"/>
							<cfinvokeargument name="formatos" 			value="V, V, V, D"/>
							<cfinvokeargument name="align" 				value="left, left, left, left"/>
							<cfinvokeargument name="ajustar" 			value="N"/>
							<cfinvokeargument name="checkboxes" 		value="S"/>
							<cfinvokeargument name="Nuevo" 				value="MovInterAlmacenconAprobacion.cfm"/>
							<cfinvokeargument name="irA" 				value="MovInterAlmacenconAprobacion.cfm"/>
							<cfinvokeargument name="keys" 				value="EMid"/>
							<cfinvokeargument name="botones" 			value="Aplicar,Nuevo"/>
							<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
						</cfinvoke>
					</td>
				</tr>
			</table>	
	<cf_web_portlet_end>
<cf_templatefooter>