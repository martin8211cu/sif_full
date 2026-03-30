<cfquery name="rsEstimacionesCreadas" datasource="#session.dsn#">
   select distinct
		 COEPeriodo,
		 Pdescripcion,p.Pid ,p.Pcodigo
	  from
		  COEstimacionIng c
		  inner join  Peaje p
		  on c.Pid = p.Pid
      where 
	  c.Ecodigo = #session.Ecodigo#
	   <cfif isdefined('form.filtro_Pcodigo') and len(trim(form.filtro_Pcodigo))>
		 and 
		<!---  <cf_dbfunction name="to_char" args="p.Pcodigo"> like <cfqueryparam cfsqltype="cf_sql_char" value="%#form.filtro_Pcodigo#%">--->
		rtrim(upper(p.Pcodigo)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_Pcodigo))#%">
	  </cfif>
	  <cfif isdefined('form.filtro_COEPeriodo') and len(trim(form.filtro_COEPeriodo))>
	    and
		<cf_dbfunction name="to_char" args="COEPeriodo"> like <cfqueryparam cfsqltype="cf_sql_char" value="%#form.filtro_COEPeriodo#%">
		<!--- and rtrim(upper(COEPeriodo)) like <cfqueryparam cfsqltype="cf_sql_integer" value="%#rtrim(Ucase(form.filtro_COEPeriodo))#%">--->
	  </cfif>
	  <cfif isdefined('form.filtro_Pdescripcion') and len(trim(form.filtro_Pdescripcion))>
		 and rtrim(upper(Pdescripcion ))like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_Pdescripcion))#%">
	  </cfif>
	  group by COEPeriodo, Pdescripcion, p.Pid, p.Pcodigo							
</cfquery>
			
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#rsEstimacionesCreadas#" 
	conexion="#session.dsn#"
	desplegar="COEPeriodo,Pcodigo,Pdescripcion"
	etiquetas="Periodo,Código,Peaje"
	formatos="S,S,S"
	mostrar_filtro="true"
	align="center,center,center"
	checkboxes="N"
	ira="EstParametrosForm.cfm"
	botones="Nuevo"
	keys="Pid,COEPeriodo, Pdescripcion">
</cfinvoke>

<!---<div align="center">
   <cf_botones modo="CAMBIO" exclude="CAMBIO,BAJA"> 
</div>
--->
 <cfoutput>
	 <script language="javascript" type="text/javascript">
		function funcNuevo()
		{		 
		  location.href='EstParametrosForm.cfm';
		}
	</script>
</cfoutput>

