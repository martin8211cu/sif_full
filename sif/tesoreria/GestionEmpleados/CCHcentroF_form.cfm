<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Codigo" default="Transacci&oacute;n" returnvariable="LB_Codigo"  xmlfile="CCHcentroF_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CentrosFuncional" default="Transacci&oacute;n" returnvariable="LB_CentrosFuncional"  xmlfile="CCHcentroF_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CentroFuncional" default="Transacci&oacute;n" returnvariable="LB_CentroFuncional" xmlfile="CCHcentroF_form.xml">

<cfquery name="CFlista" datasource="#session.dsn#">
	select cf.CFid,cf.CFdescripcion,cf.CFcodigo, #form.CCHid# as CCHid
	from CCHicaCF c
		inner join CFuncional cf
		on c.CFid=cf.CFid
	where c.CCHid=#form.CCHid#
	and c.Ecodigo=#session.ecodigo#
</cfquery>
<!---<cfdump var="#CFlista#">--->


	<table width="100%">
		<tr>
			<td width="50%" align="left">
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#CFlista#"
				columnas="CFcodigo,CFdescripcion"
				desplegar="CFcodigo,CFdescripcion"
				etiquetas="#LB_Codigo#,#LB_CentrosFuncional#"
				formatos="S,S"
				keys="cfid"
				align="left,left"
				irA="CCHapertura.cfm"
				form_method="post"	
				checkboxes="N"
				PageIndex="1"
				MaxRows="5"	
				navegacion="&CCHid=#form.CCHid#"			
				showEmptyListMsg="yes"		
				showLink="yes"
				formName="form2"
				incluyeForm="yes"									
				/>	
			</td>
		<form name="form3" action="CCHapertura_sql.cfm" method="post">
		<input name="CCHid" value="<cfoutput>#form.CCHid#</cfoutput>" type="hidden">
			<td width="50%" align="left" nowrap="nowrap" valign="top" >
				<strong><cfoutput>#LB_CentroFuncional#</cfoutput>:</strong>		
				<cfif isdefined ('form.cfid')>
					<cfquery name="rsCFuncional" datasource="#session.dsn#">
						select CFid , CFcodigo, CFdescripcion
						from CFuncional
						where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cfid#">
					</cfquery>				
					
					<cf_rhcfuncional form="form3" tabindex="1" query="#rsCFuncional#" >
					<!---<cfdump var="#rsCFuncional#">--->
				<cfelse>
					<cf_rhcfuncional form="form3" tabindex="1">
				</cfif>
				
				
			</td>
		</tr>
		<tr>
			<td align="center" colspan="7" >
				<cfif not isdefined ('form.CFid')>
					<cf_botones form="form3" names="agregaCF,nuevoCF" values="Agregar,Nuevo">
				<cfelse>
					<cf_botones form="form3" names="nuevoCF,eliminaCF" values="Nuevo,Eliminar" >
			</cfif>
			</td>
		</tr>		
		</form>
	</table>


<!---<script language="javascript1.1" type="text/javascript">
	function jsenvia (){
		document.form3.action = 'CCHapertura_sql.cfm';
		document.form3.submit;
	}
</script>--->
