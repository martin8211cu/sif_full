<cf_templateheader title="SIF - Quick Pass">
	<cf_web_portlet_start border="true" titulo="Lista de Inconsistencias">
	
<cfset fnObtieneDatosLista()>
<table width="100%" border="0" cellspacing="6">
	<tr>
		<td width="60%" valign="top">
				<cfif isdefined("url.FiltroFechaD") and len(trim(url.FiltroFechaD))>
					<cfset form.FiltroFechaD = url.FiltroFechaD>
				</cfif>					
				<cfif isdefined("url.FiltroFechaH") and len(trim(url.FiltroFechaH))>
					<cfset form.FiltroFechaH = url.FiltroFechaH>
				</cfif>
				
				<!-- Aqui van los campos Llave Definidos para la tabla -->
				<cfif isdefined("url._")>
					<cf_navegacion name = "FiltroFechaD" default = "">
					<cf_navegacion name = "FiltroFechaH" default = "">
				<cfelse>
					<cf_navegacion name = "FiltroFechaD" default = "" session="">
					<cf_navegacion name = "FiltroFechaH" default = "" session="">
				</cfif>	
		<cfoutput>
			<form action="QPassInconsistencias.cfm" name="form2" method="post" onsubmit="return validar(this);">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td class="titulolistas"><strong>Fechas Desde</strong></td>
						<td class="titulolistas" colspan="3"><strong>Fecha Hasta</strong></td>
					</tr>
					<tr>
						<td class="titulolistas"><cfif isdefined('form.FiltroFechaD')><cf_sifcalendario form="form2" value="#form.FiltroFechaD#" name="FiltroFechaD" tabindex="1"><cfelse><cf_sifcalendario form="form2" value="" name="FiltroFechaD" tabindex="1"></cfif></td>
						<td class="titulolistas"><cfif isdefined('form.FiltroFechaH')><cf_sifcalendario form="form2" value="#form.FiltroFechaH#" name="FiltroFechaH" tabindex="1"><cfelse><cf_sifcalendario form="form2" value="" name="FiltroFechaH" tabindex="1"></cfif></td>
                        <td class="titulolistas"><input name="chkExportar" id="chkExportar" type="checkbox" value="1" border="0" style="background:background-color "> <label for="chkExportar">Exportar Archivo Plano</label></td>
						<td class="titulolistas"><cf_botones values="Filtrar" tabindex="1" functions = "funcFiltrar();"></td>
					</tr>
				</table> 
						<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
						<label for="chkTodos">Seleccionar Todos</label>
				
			</form>	
			
		</cfoutput>
			   <cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
				   <cfinvokeargument name="query"            value="#rsLista#"/>
				   <cfinvokeargument name="desplegar"        value="QPTPAN,QPMCdescripcion,QPMCMonto,BMFecha,QPMCintento,QPMCerrordesc"/>
				   <cfinvokeargument name="etiquetas"        value="N° TAG,Descripción, Monto, Fecha,Intento,Error"/>
				   <cfinvokeargument name="formatos"         value="S,S,M,D,S,S"/>
				   <cfinvokeargument name="align"            value="left,left,left,left,center,left"/>
				   <cfinvokeargument name="ajustar"          value="S"/>
				   <cfinvokeargument name="irA"              value="QPassInconsistencias_SQL.cfm"/>
				   <cfinvokeargument name="showEmptyListMsg" value="true"/>
				   <cfinvokeargument name="keys"             value="QPMid"/>
				   <cfinvokeargument name="mostrar_filtro"   value="false"/>
				   <cfinvokeargument name="showEmptyListMsg" value="true"/>
				   <cfinvokeargument name="showLink"         value="false"/>
				   <cfinvokeargument name="checkboxes"       value="S"/>
				   <cfinvokeargument name="formname"       value="form3"/>
				   <cfinvokeargument name="botones"          value="Reprocesar,Eliminar"/>
			   </cfinvoke>
			</td>	
		</tr>
	</table>	
<cf_web_portlet_end>
<cf_templatefooter>

<cffunction name="fnObtieneDatosLista" access="private" output="false">
   <cfquery name="rsLista" datasource="#session.DSN#">
		select
			a.QPMid,
			a.QPMestado,
			a.Ecodigo,
			a.QPTPAN,
			a.QPMCFInclusion,
			a.QPMCMonto,
			a.QPMCdescripcion,
			coalesce(a.QPMCintento,0) as QPMCintento ,
			a.QPMCerrordesc,
			a.BMFecha
		from QPMovInconsistente a
		where a.Ecodigo = #session.Ecodigo#

		<cfif isdefined("form.FiltroFechaD") and len(trim(form.FiltroFechaD)) and isdefined("form.FiltroFechaH") and len(trim(form.FiltroFechaH))>
			and a.BMFecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FiltroFechaD)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FiltroFechaH)#">	
		<cfelseif isdefined("form.FiltroFechaH") and len(trim(form.FiltroFechaH)) and form.FiltroFechaD eq ''>
			and a.BMFecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FiltroFechaH)#">
		<cfelseif isdefined("form.FiltroFechaD") and len(trim(form.FiltroFechaD)) and form.FiltroFechaH eq ''>
			and a.BMFecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FiltroFechaD)#">
		</cfif> 
		and QPMestado = 0
	   order by a.BMFecha asc,a.QPTPAN
   </cfquery>
</cffunction>

    <script language="javascript1" type="text/javascript">
		function funcEliminar(elimina){
			if (algunoMarcadoE())
				document.form3.action = "QPassInconsistencias_SQL.cfm";
			else
				return false;
			return true;
		}	
		
		function funcReprocesar(reprocesa){
			if (algunoMarcadoR())
				document.form3.action = "QPassInconsistencias_SQL.cfm";
			else
				return false;
			return true;
		}	

		
		function funcFiltrar(){
			if(!document.form2.chkExportar.checked){
				document.form2.action='QPassInconsistencias.cfm';
				document.form2.submit;
			}else{
				document.form2.action='QPassInconsistencias_SQL.cfm';
				document.form2.submit;
			}
		}
		
		function algunoMarcadoR(){
			var reprocesa = false;
			
			if (document.form3.chk) {
				if (document.form3.chk.value) {
					reprocesa = document.form3.chk.checked;
				} else {
					for (var i=0; i<document.form3.chk.length; i++) {
						if (document.form3.chk[i].checked) { 
							reprocesa = true;
							break;
						}
					}
				}
			}
			if (reprocesa) {
				return (confirm("¿Está seguro de que desea Reprocesar el registro seleccionado?"));
			} else {
				alert('Debe seleccionar al menos un registro antes de Reprocesar');
				return false;
			}
		}
	
	function algunoMarcadoE(){
		var elimina = false;
			if (document.form3.chk) {
				if (document.form3.chk.value) {
					elimina = document.form3.chk.checked;
				} else {
					for (var i=0; i<document.form3.chk.length; i++) {
						if (document.form3.chk[i].checked) { 
							elimina = true;
							break;
						}
					}
				}
			}
			if (elimina) {
				return (confirm("¿Está seguro de que desea Eliminar el registro seleccionado?"));
			} else {
				alert('Debe seleccionar al menos un registro antes de Eliminar');
				return false;
			}
		}
		
		function fnFechaYYYYMMDD (LvarFecha)
			{
				return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
			}
		
		function validar(formulario)
		{
				var error_input;
				var error_msg = '';
		
			if (fnFechaYYYYMMDD(document.form2.FiltroFechaD.value) > fnFechaYYYYMMDD(document.form2.FiltroFechaH.value)
			& fnFechaYYYYMMDD(document.form2.FiltroFechaH.value) != '')
			{
				alert ("La Fecha Hasta no puede ser menor a la Fecha Desde");
				return false;
			}
			else
			{ return true;
			}
		}
		
		function Marcar(c) {
			if (c.checked) {
				for (counter = 0; counter < document.form3.chk.length; counter++)
				{
					if ((!document.form3.chk[counter].checked) && (!document.form3.chk[counter].disabled))
						{  document.form3.chk[counter].checked = true;}
				}
				if ((counter==0)  && (!document.form3.chk.disabled)) {
					document.form3.chk.checked = true;
				}
			}
			else {
				for (var counter = 0; counter < document.form3.chk.length; counter++)
				{
					if ((document.form3.chk[counter].checked) && (!document.form3.chk[counter].disabled))
						{  document.form3.chk[counter].checked = false;}
				};
				if ((counter==0) && (!document.form3.chk.disabled)) {
					document.form3.chk.checked = false;
				}
			};
		}    
</script>

