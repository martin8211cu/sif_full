<!--- * modificado en notepad para incluir el boom * --->
<cfparam name="url.PEXTid" default="">
<cfquery datasource="#session.dsn#" name="data">
	select *
	from  RHPagosExternosTipo where PEXTid =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PEXTid#" null="#Len(url.PEXTid) Is 0#">
</cfquery>
<cfoutput>
<form action="RHPagosExternosTipo-apply.cfm" enctype="multipart/form-data" method="post" name="form1" id="form1">
	<table width="1%" align="center" summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	#LB_RHPagosExternosTipo#
	</td></tr>
	
		<tr><td valign="top" nowrap><label for="PEXTcodigo">#LB_Codigo#</label>
		</td><td valign="top">
		
			<input name="PEXTcodigo" id="PEXTcodigo" type="text" value="#HTMLEditFormat(data.PEXTcodigo)#" 
				maxlength="3" tabindex="1"
				onfocus="this.select()"  >
		
		</td></tr>
		
		<tr><td valign="top" nowrap><label for="PEXTdescripcion">#LB_Descripcion#</label>
		</td><td valign="top">
		
			<input name="PEXTdescripcion" id="PEXTdescripcion" type="text" value="#HTMLEditFormat(data.PEXTdescripcion)#" 
				maxlength="80" tabindex="1"
				onfocus="this.select()"  >
		
		</td></tr>
		
		<tr><td valign="top">
		
			
		
		</td><td valign="top"><input name="PEXTsirenta" id="PEXTsirenta" type="checkbox" <cfif HTMLEditFormat(data.PEXTsirenta) EQ 1>checked</cfif> ><label for="PEXTsirenta">#LB_PEXTsirenta#</label>
		</td></tr>
		
		<tr><td valign="top">
		
			
		
		</td><td valign="top"><input name="PEXTsicargas" id="PEXTsicargas" type="checkbox" <cfif HTMLEditFormat(data.PEXTsicargas) EQ 1>checked</cfif> onClick="javascript:funcDesactivarCarga();"><label for="PEXTsicargas">#LB_PEXTsicargas#</label>
		</td></tr>


		<tr><td colspan="2">
			
		<div id="div_DClinea">
			<table>
				<tr>
					<td valign="top" nowrap>
						<label for="PEXTdescripcion">#LB_DClinea#</label>
					</td>
					
					<td valign="top">
						<cfquery name="rsdatatemp" datasource="#session.dsn#">
							select 
								t.DClinea as c1,
								t.DCcodigo as c2,
								t.DCdescripcion as c3
							from DCargas t
							where t.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DClinea#" null="#Len(data.DClinea) Is 0#">
						</cfquery>
			
						<cfset valuesarray = ArrayNew(1)>
						<cfif rsdatatemp.recordcount gt 0>			
							<cfset ArrayAppend(valuesarray,rsdatatemp.c1)>
							<cfset ArrayAppend(valuesarray,rsdatatemp.c2)>
							<cfset ArrayAppend(valuesarray,rsdatatemp.c3)>
						</cfif>
			
						<cf_conlis title="#LB_Titulo#"
							valuesarray="#valuesarray#"
							campos="DClinea, DCcodigo, DCdescripcion"
							desplegables="N,S,S"
							modificables="N,S,N"
							columnas="DClinea, DCcodigo, DCdescripcion"
							tabla="DCargas"
							filtro="Ecodigo=#Session.Ecodigo# order by 2"
							desplegar="DCcodigo, DCdescripcion"
							etiquetas="#LB_Codigo#, #LB_Descripcion#"
							formatos="S,S"
							align="left,left"
							asignar="DClinea, DCcodigo, DCdescripcion"
							asignarformatos="S,S,S"
						/>
		
					</td>
				</tr>
			</table>
		</div>
		
		</td>
	</tr>				
				
	<tr><td colspan="2" class="formButtons" >
		<cfif data.RecordCount>
			<cf_botones  regresar="RHPagosExternosTipo.cfm" modo="CAMBIO" tabindex="1" width="500">
		<cfelse>
			<cf_botones  regresar="RHPagosExternosTipo.cfm" modo="ALTA" tabindex="1" width="500">
		</cfif>
	</td></tr>
	</table>
	
	
			<input type="hidden" name="PEXTid" value="#HTMLEditFormat(data.PEXTid)#">
		
			<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(data.Ecodigo)#">
		
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
			
</form>
</cfoutput>

<script language="javascript">
	function onValidate(){
		funcDesactivarCarga();
	}
</script>

<cf_qforms onValidate="onValidate">
	<cf_qformsrequiredfield args="PEXTcodigo,#JS_Codigo#">
	<cf_qformsrequiredfield args="PEXTdescripcion,#JS_Descripcion#">
</cf_qforms>

<cfoutput>
<script language="javascript">
	function funcDesactivarCarga(){
		if (!objForm.PEXTsicargas.obj.checked){
			objForm.DClinea.obj.value="";
			objForm.DCcodigo.obj.value="";
			objForm.DCdescripcion.obj.value="";
			objForm.DClinea.required=false;
			document.getElementById("div_DClinea").style.visibility='hidden';
		}else{
			objForm.DClinea.description="#JS_DClinea#";
			objForm.DClinea.required=true;
			document.getElementById("div_DClinea").style.visibility='';
		}
	}
	funcDesactivarCarga();
</script>
</cfoutput>