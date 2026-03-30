<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="La categoría_X_ya_fue_asignada_al_puesto_X"
Default="La categoría: #form.RHCdescripcion# ya fue asignada al puesto #form.RHMPPcodigo# - #form.RHMPPdescripcion#"
returnvariable="MG_YaAsignado"/> 

<cfoutput>
<cftransaction>
    
	<cfif isdefined("Form.BTNagregar")>			
		<!----Validar que no exista ya la combinacion Puesto/Categoria/Tabla---->
		<cfquery name="rsValida" datasource="#session.DSN#">
			select 1 from RHCategoriasPuesto
			where RHTTid = <cfqueryparam value="#form.RHTTid#" cfsqltype="cf_sql_numeric">
				<cfif isdefined('form.RHMPPid') and #form.RHMPPid# GT 0>
                	and RHMPPid = <cfqueryparam value="#form.RHMPPid#" cfsqltype="cf_sql_numeric">
               	</cfif>
				and RHCid = <cfqueryparam value="#form.RHCid#" cfsqltype="cf_sql_numeric"> 
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsValida.RecordCount EQ 0>	
			<cfquery name="rsinsert" datasource="#Session.DSN#">
				insert into RHCategoriasPuesto(Ecodigo, RHTTid, RHMPPid, RHCid, Mcodigo, BMfecha, BMUsucodigo, RHCPlinearef)
					values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							 <cfqueryparam value="#form.RHTTid#" cfsqltype="cf_sql_numeric">,
                             <cfif isdefined('form.RHMPPid') and #form.RHMPPid# GT 0>
								 <cfqueryparam value="#form.RHMPPid#" cfsqltype="cf_sql_numeric">,
                             <cfelse>
                             	null ,
                             </cfif>
							 <cfqueryparam value="#form.RHCid#" cfsqltype="cf_sql_numeric">,
							 <cfif isdefined("Form.Mcodigo") and len(trim(Form.Mcodigo))><cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
							  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,						 
							 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
							 <cfif isdefined("form.RHCPlinearef") and len(trim(form.RHCPlinearef))>
							 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPlinearef#">
							 <cfelse>
							 	null
							 </cfif>
							 )
				<cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsinsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsinsert.Identity>
            
            <cfif isdefined('form.RHMPPid') and #form.RHMPPid# GT 0>
                <cfquery name="rsDcomponentes" datasource="#session.DSN#">
                    select RHCCid, RHCid, CSid 
                    from RHCcomponentes
                    where RHCid = <cfqueryparam value="#form.RHCid#" cfsqltype="cf_sql_numeric">
                </cfquery>
                <cfif rsDcomponentes.RecordCount GT 0>
                    <cfloop query="rsDcomponentes">
                        <cfquery datasource="#session.dsn#">
                            insert into RHCPcomponentes (RHCPlinea,CSid)
                            values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDcomponentes.CSid#">)
                        </cfquery>
                    </cfloop>
                </cfif>
            </cfif>
		<cfelse>
			<cf_throw message="#MG_YaAsignado#" errorcode="7020">
		</cfif>
	<!----/////// Eliminar categoria a puesto ///////----->	
	<cfelseif isdefined("form.chk") and len(trim(form.chk))>
		<cfquery name="insert" datasource="#Session.DSN#">
			delete from RHCategoriasPuesto
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHCPlinea in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#" list="yes" >)
		</cfquery>	
	</cfif>
</cftransaction>	
<form action="TablaPuestoCategoria.cfm" method="post" name="sql">
	<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>
		<cfquery name="rsHayCategorias" datasource="#session.DSN#">
			select 1 from RHCategoriasPuesto 
			where RHTTid = <cfqueryparam value="#form.RHTTid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif isdefined("rsHayCategorias") and rsHayCategorias.RecordCount NEQ 0>
			<input type="hidden" name="RHTTid" value="#form.RHTTid#">
		</cfif>
	</cfif>	
	
	<cfif isdefined('form.Filtro_RHMPPcodigoL') and LEN(TRIM(form.Filtro_RHMPPcodigoL))>
		<input name="Filtro_RHMPPcodigoL" type="hidden" value="#form.Filtro_RHMPPcodigoL#">
	</cfif>
	<cfif isdefined('form.Filtro_RHMPPdescripcionL') and LEN(TRIM(form.Filtro_RHMPPdescripcionL))>
		<input name="Filtro_RHMPPdescripcionL" type="hidden" value="#form.Filtro_RHMPPdescripcionL#">
	</cfif>
	<cfif isdefined('form.HFiltro_RHMPPcodigoL') and LEN(TRIM(form.HFiltro_RHMPPcodigoL))>
		<input name="HFiltro_RHMPPcodigoL" type="hidden" value="#form.HFiltro_RHMPPcodigoL#">
	</cfif>
	<cfif isdefined('form.HFiltro_RHMPPdescripcionL') and LEN(TRIM(form.HFiltro_RHMPPdescripcionL))>
		<input name="HFiltro_RHMPPdescripcionL" type="hidden" value="#form.HFiltro_RHMPPdescripcionL#">
	</cfif>

	<cfif isdefined('form.Filtro_RHCcodigoL') and LEN(TRIM(form.Filtro_RHCcodigoL))>
		<input name="Filtro_RHCcodigoL" type="hidden" value="#form.Filtro_RHCcodigoL#">
	</cfif>
	<cfif isdefined('form.Filtro_RHCdescripcionL') and LEN(TRIM(form.Filtro_RHCdescripcionL))>
		<input name="Filtro_RHCdescripcionL" type="hidden" value="#form.Filtro_RHCdescripcionL#">
	</cfif>
	<cfif isdefined('form.HFiltro_RHCcodigoL') and LEN(TRIM(form.HFiltro_RHCcodigoL))>
		<input name="HFiltro_RHCcodigoL" type="hidden" value="#form.HFiltro_RHCcodigoL#">
	</cfif>
	<cfif isdefined('form.HFiltro_RHCdescripcionL') and LEN(TRIM(form.HFiltro_RHCdescripcionL))>
		<input name="HFiltro_RHCdescripcionL" type="hidden" value="#form.HFiltro_RHCdescripcionL#">
	</cfif>  
	
</form>
</cfoutput>	
<HTML><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>


