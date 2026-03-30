
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="El_codigo_de_categoria_ya_existe"
Default="El c&oacute;digo de categor&iacute;a ya existe."
returnvariable="MG_CategoriaYaExiste"/> 


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="El_registro_no_se_puede_eliminar_porque_es_una_categoria_padre"
Default="El registro no se puede eliminar porque es una categor&iacute;a padre"
returnvariable="MG_EliminarCategoria"/> 


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Ha_ocurrido_un_error_Comuniquese_con_el_encargado_de_soporte_de_la_aplicacion"
Default="Ha ocurrido un error.  Comuniquese con el encargado de soporte de la aplicaci&oacute;n"
returnvariable="MG_Error"/> 


<cfif isdefined('form.AltaDComponentes') and isdefined('form.ComboComponentes')>
	<cfquery datasource="#session.dsn#" name="validaComponentes">
        select 1 from RHCcomponentes
        where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
        and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ComboComponentes#">
	</cfquery>
	<cfif validaComponentes.recordcount eq 0>
		<cfquery datasource="#session.dsn#">
		insert into RHCcomponentes (RHCid,CSid)
		values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ComboComponentes#">)
		</cfquery>
	</cfif>	

</cfif>

<cfif isdefined("form.btnEliminar") and isdefined("form.CHK")>
	<cfset deleteCSid=''>
	<cfloop list="#form.CHK#" delimiters="," index="i">
		<cfset deleteCSid=listAppend(deleteCSid,ListGetAt(i,3,'|'))>
	</cfloop>
	<cfquery datasource="#session.dsn#" name="a">
	delete from RHCcomponentes 
	where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
	and CSid in (#deleteCSid#)
	</cfquery>
</cfif>


<cfset modo = "ALTA">
<!-----Modo alta---->
<cfif isdefined("Form.Alta")>				
	<cfset my_path = Trim(form.RHCcodigo)>
	<cfset my_nivel = 0>
	<cfif len(trim(Form.RHCidpadre))>
		<cfquery name="path_papa" datasource="#session.dsn#">
			select path, nivel
			from RHCategoria
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCidpadre#">
		</cfquery>
		<cfif path_papa.RecordCount>
			<cfset my_path = Trim(path_papa.path) & '/' & my_path>
			<cfset my_nivel = path_papa.nivel + 1>
		</cfif>
	</cfif>
	
	<cftransaction>				
		<!---Validar que el código digitado no exista---->
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select RHCid from RHCategoria
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCcodigo#">			
		</cfquery>
		<cfif rsVerifica.RecordCount EQ 0>
			<cfquery datasource="#session.dsn#" name="rsInsert">
				insert into RHCategoria (Ecodigo,
										RHCcodigo,				
										RHCdescripcion,
										RHCidpadre,
										path,
										nivel,
										BMfecha,
										BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCcodigo#">,						
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.RHCdescripcion#">,
						<cfif isdefined("form.RHCidpadre") and len(trim(form.RHCidpadre))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCidpadre#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#my_path#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#my_nivel#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
			 <cf_dbidentity1>
			</cfquery>
			<cf_dbidentity2 name="rsInsert">
			<cf_translatedata name="set" tabla="RHCategoria" col="RHCdescripcion" valor="#form.RHCdescripcion#" filtro="RHCid = #rsInsert.identity#">
		<cfelse>
			<cf_throw message="#MG_CategoriaYaExiste#" errorcode="7005">
		</cfif>						
		<!-----<cf_dbidentity2 datasource="#Session.DSN#" name="CFuncional">------>
	</cftransaction>
<!----Modo BAJA---->
<cfelseif IsDefined("form.Baja")>
	<cfquery name="rsValida" datasource="#session.DSN#">
		select RHCid from RHCategoria
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCidpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
	</cfquery>	
	<cfif rsValida.RecordCount NEQ 0>
		<cf_throw message="#MG_EliminarCategoria#" errorcode="7010">
	<cfelse>		
		<cftry>
			<cfquery datasource="#session.dsn#">
				delete RHCategoria
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
					and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>			
			<cfcatch type="database">
				<cf_errorcode code="50581" msg="No se puede eliminar porque tiene datos asociados">
			</cfcatch>
		</cftry>
	</cfif>
<!----Modo CAMBIO----->
<cfelseif IsDefined("form.Cambio")>
	<!---Validar que el código de la categoría no exista---->
	<cfif isdefined("form.RHCcodigo") and len(trim(form.RHCcodigo)) and isdefined("form._RHCcodigo") and len(trim(form._RHCcodigo)) and form.RHCcodigo NEQ form._RHCcodigo>
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select RHCid from RHCategoria
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHCcodigo = <cfqueryparam cfsqltype="cf_sql_char" 	value="#form.RHCcodigo#">
		</cfquery>	
	</cfif>
	
	<cfif not isdefined("rsVerifica") or (isdefined("rsVerifica") and rsVerifica.RecordCount EQ 0)>
		<cfquery datasource="#session.dsn#" name="valores_anteriores">
			select RHCcodigo, RHCidpadre
			from RHCategoria
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHCid = <cfqueryparam value="#Form.RHCid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cf_dbtimestamp datasource="#session.dsn#"
			table="RHCategoria"
			redirect="RHCategoria.cfm"
			timestamp="#form.ts_rversion#"
			field1="RHCid"
			type1="numeric"
			value1="#form.RHCid#">	
		
		<cfquery datasource="#session.dsn#">
			update 	RHCategoria
			set 	RHCcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#form.RHCcodigo#">,
					RHCdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.RHCdescripcion#">,
					<cfif isdefined("Form.RHCidpadre") and Len(Trim(Form.RHCidpadre)) GT 0>									
						<cfif Compare(Trim(Form.RHCid),Trim(Form.RHCidpadre)) EQ 0>
							RHCidpadre = null
						<cfelse>		
							<cfif len(trim(Form.RHCidpadre)) GT 0>
								RHCidpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCidpadre#">
							<cfelse>
								RHCidpadre = null
							</cfif>				
						</cfif>										
					<cfelse>
						RHCidpadre	 = null
					</cfif>		
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
				and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cf_translatedata name="set" tabla="RHCategoria" col="RHCdescripcion" valor="#form.RHCdescripcion#" filtro="RHCid = #form.RHCid#">

		<cfif Trim(valores_anteriores.RHCcodigo) neq Trim(form.RHCcodigo) or Trim(valores_anteriores.RHCidpadre) neq Trim(form.RHCid)>
			<!--- reordenar todo el arbol pues ha cambiado la estructura del arbol --->
			<cfquery datasource="#session.dsn#">
				update RHCategoria
				  set path =  ltrim(rtrim(RHCcodigo)),
					  nivel = case when RHCidpadre is null then 0 else -1 end
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset nivel = 0>
			<cfloop from="0" to="100" index="nivel">
				<cfif nivel is 100>
					<cf_throw message="#MG_Error#" errorcode="7015">
				</cfif>
				<cf_dbfunction name="concat" args="p.path,'/',ltrim(rtrim(RHCategoria.RHCcodigo))" returnvariable="Lvar_path">
				<cf_dbupdate table="RHCategoria" datasource="#session.DSN#" > 
					<cf_dbupdate_join table="RHCategoria p">
						on RHCategoria.RHCidpadre = p.RHCid
							and RHCategoria.Ecodigo = p.Ecodigo
							and RHCategoria.nivel = -1
					</cf_dbupdate_join>
					
					<cf_dbupdate_set name='path' 
						expr="#Lvar_path#" />
					<cf_dbupdate_set name='nivel' type="integer" value="#nivel + 1#"/>
					
					<cf_dbupdate_where>
						where RHCategoria.Ecodigo = <cf_dbupdate_param type="integer" value="#session.Ecodigo#">
						  and p.Ecodigo = <cf_dbupdate_param type="integer" value="#session.Ecodigo#">
						  and p.nivel = <cf_dbupdate_param type="numeric" value="#nivel#">
					</cf_dbupdate_where>						
				</cf_dbupdate>
	
				<cfquery datasource="#session.dsn#" name="hay_mas">
					select count(1) as cuantos
					from RHCategoria h, RHCategoria p
				   where h.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					 and h.nivel = -1
				</cfquery>
				<cfif isdefined('hay_mas') and hay_mas.cuantos is 0><cfbreak></cfif>
	
			</cfloop>
		</cfif>
	<cfelse>
		<cf_throw message="MG_CategoriaYaExiste" errorcode="7005">
	</cfif><!---Fin de si ya existe el código de la categoría---->
<cfelseif isdefined("form.Nuevo")>
	<cfquery name="rsEsPadre" datasource="#session.DSN#">
		select count(RHCid) as hijos
		from RHCategoria
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and RHCidpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCid#">
	</cfquery>
	<cfif rsEsPadre.hijos NEQ 0>
		<cfset vn_padre = form.RHCid>
	</cfif>
</cfif>



<cfoutput>
<form action="RHCategoria.cfm" method="post" name="sql">
	<cfif isdefined("form.Cambio") or isdefined("form.AltaDComponentes") or isdefined("form.btnEliminar")>
		<input name="RHCid" type="hidden" value="#form.RHCid#">
	</cfif>
	<cfif isdefined("vn_padre") and len(trim(vn_padre))>
		<input name="RHCidpadre" type="hidden" value="#vn_padre#">
	</cfif>
	<input type="hidden" name="dummi" value="">
</form>
</cfoutput>
<HTML><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>



