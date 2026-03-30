<cfset navegacion = "">

	<cfquery datasource="#session.dsn#" name="lista">
		select 
		CxCGid,
		CxCGdescrip,     
		CxCGcod,                  
		Ecodigo,         
		BMUsucodigo,     
		SNCEid,          
		SNCDid,          
		CCTcodigoR, 
		CCTcodigoD,     
		ID,          
		Ocodigo    
		from 
		CxCGeneracion ant
		where ant.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined('form.codigo') and len(trim(form.codigo))>
			and CxCGcod = '#form.codigo#'
		</cfif>
		<cfif isdefined('form.TransaccionD') and len(trim(form.TransaccionD)) and  form.TransaccionD neq '-1'>
			and ant.CCTcodigoD  = '#form.TransaccionD#'
		</cfif>
		
		<cfif isdefined('form.TransaccionR') and len(trim(form.TransaccionR)) and  form.TransaccionR neq '-1'>
			and ant.CCTcodigoR  = '#form.TransaccionR#'
		</cfif>
	</cfquery>
 
	<cfquery name="transaccionesD" datasource="#session.dsn#">
		select CCTcodigo,CCTdescripcion 
		from CCTransacciones
		where CCTtipo= 'D' 
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and CCTvencim <> -1
	</cfquery>
		
	<cfquery name="transaccionesR" datasource="#session.dsn#">
		select CCTcodigo,CCTdescripcion 
		from CCTransacciones
		where CCTtipo= 'C' 
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and CCTpago=1
	</cfquery>

	<form style="margin:0" action="generacion.cfm" method="post" name="formLista" >           
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
		<tr> 
		  <td width="2%">&nbsp;</td>
		  <td><strong>Código</strong></td>
		  <td><strong>Transacción de Documento</strong></td>
		  <td><strong>Transacción de Recibo</strong></td>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
		</tr>
		<tr> 
		  <td>&nbsp;</td>
		  <td>
			<input type="text" name="codigo" />
		  </td>
		  <td>
			 <select name="TransaccionD">
			  <option value="-1">Todas</option>
			  <cfoutput query="transaccionesD"> 
				<option value="#transaccionesD.CCTcodigo#" <cfif isdefined ("form.TransaccionD") and len(trim(form.TransaccionD)) and form.TransaccionD eq transaccionesD.CCTcodigo>selected</cfif>>#transaccionesD.CCTcodigo# - #transaccionesD.CCTdescripcion#</option>
			  </cfoutput> 
			</select>
		  </td>
		  
		  <td>
			  <select name="TransaccionR">
			  <option value="-1">Todas</option>
			  <cfoutput query="transaccionesR"> 
				<option value="#transaccionesR.CCTcodigo#" <cfif isdefined ("form.TransaccionD") and len(trim(form.TransaccionR)) and form.TransaccionR eq transaccionesR.CCTcodigo>selected</cfif>>#transaccionesR.CCTcodigo# - #transaccionesR.CCTdescripcion#</option>
			  </cfoutput> 
			 </select>
		   </td>
		  <td width="1%"><cf_botones values="Filtrar" name="Filtrar" tabindex="1">
		  </td>
		  <td width="1%">
		   <cf_botones values="Nuevo" tabindex="1">
		  </td>
		</tr>
	  </table>
	  
	 <table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr> 
		  <td width="2%" class="tituloListas" colspan="6">
			<input name="datos" type="hidden" value="">
		  </td>
		</tr>
		  <td ></td>
		  <td>
		  <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="CxCGcod,CxCGdescrip,CCTcodigoD,CCTcodigoR"
			etiquetas="Código,Descripci&oacute;n,Transacción de Documento,Transacción de Recibos"
			formatos="S,S,S,S"
			align="left,left,left,left"
			ira="generacion.cfm" 
			showEmptyListMsg="yes"
			MaxRows="15"
			showLink="yes"
			incluyeForm="yes"
			formName="formLista"
			form_method="post"	
			keys="CxCGid"	
			navegacion="#navegacion#"
			botones= "Nuevo"
			/>
		</td>
	</tr>
	<td>&nbsp;</td>
		<tr> 
		</tr>
	  </table>
</form>	  

<script language="javascript1" type="text/javascript">
	function funcFiltrar(){
		document.formLista.method='post';
		document.formLista.action='generacion.cfm';
		
	}
</script>




