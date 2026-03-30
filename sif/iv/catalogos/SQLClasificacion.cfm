<!---<cf_dump var="#form#">--->
<cfset params = "">
<cffunction name="datos" returntype="query">
	<cfargument name="padre" required="yes" type="numeric">
	<cfquery name="data" datasource="#session.DSN#">
		select Cnivel, Cpath
		from Clasificaciones
		where Ecodigo =  #session.Ecodigo# 
		and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.padre#">
	</cfquery>
	<cfreturn data >
</cffunction>

<cffunction name="_nivel" returntype="boolean">
	<cfargument name="nivel" required="yes" type="numeric">
	<cfquery name="data" datasource="#session.DSN#">
		select coalesce(Pvalor, '1') as Pvalor
		from Parametros
		where Ecodigo =  #session.Ecodigo# 
		and Pcodigo = 530
	</cfquery>

	<cfif (nivel+1) gt data.Pvalor>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cfif not isdefined("Form.Nuevo")>
	<!--- Si viene el boton de aplicar(Aplicar)se asigna al CAid (codigo aduanal) del articulo el CAid de la clasificacion --->
	<cfif isdefined("form.Aplicar")>
		<cfquery name="updateArticulos" datasource="#session.DSN#">
				update Articulos
				set CAid = <cfif isdefined("form.CAid") and len(trim(form.CAid))><cfqueryparam value="#Form.CAid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>
				where Ecodigo =  #session.Ecodigo# 
				 and Ccodigo  = <cfqueryparam value="#form.Ccodigo#"    cfsqltype="cf_sql_integer" >
		</cfquery>
		<cfset params = params & "?arbol_pos=#form.Ccodigo#">
	<!--- Si viene del boton de aplicar certificación (AplicarCertificacion) se asigna al Areqcert (requiere certificación) del articulo el Creqcert de la clasificacion --->
	<cfelseif isdefined("form.AplicarCertificacion")>
		<cfquery name="updateCertificacionArticulos" datasource="#session.DSN#">
			update Articulos
			<cfif isdefined("form.Creqcert")>
			set Areqcert = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
			<cfelse>
			set Areqcert = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			</cfif>
			where Ecodigo =  #session.Ecodigo# 
			  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
		</cfquery>
		<cfset params = params & "?arbol_pos=#form.Ccodigo#">
	</cfif>
	
	<cfset nivel = 0 >
	<cfset path  = RepeatString("*", 5-len(trim(form.Ccodigoclas)) ) & "#trim(form.Ccodigoclas)#" >
	<cfif isdefined("Form.Alta") or isdefined("form.CAMBIO")>
		<cfif isdefined("form.Ccodigopadre") and len(trim(form.Ccodigopadre))>
			<cfset _datos = datos(form.Ccodigopadre) >
			<cfset nivel = _datos.Cnivel + 1>
			<cfset path  = trim(_datos.Cpath) & "/" & trim(path) >
			
			<cfif not _nivel(nivel) >
				<cf_errorCode	code = "50043" msg = "Ha excedido el nivel máximo para la Clasificación de Artículos.">
			</cfif>
		</cfif>
	</cfif>
	
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsconsecutivo" datasource="#session.DSN#">
			select coalesce(max(Ccodigo),0) as codigo
			from Clasificaciones
			where Ecodigo= #session.Ecodigo# 
		</cfquery>
		<cfset consecutivo = 1 >
		<cfif rsconsecutivo.recordcount gt 0 and len(trim(rsconsecutivo.codigo))>
			<cfset consecutivo = rsconsecutivo.codigo + 1>
		</cfif>
		<cfset LvarCconsecutivo = "null">
		<cfif isDefined("form.consecutivo") and form.consecutivo GT 0>
            <cfset LvarCconsecutivo = Form.consecutivo>                
        </cfif>
		<cfquery name="insert" datasource="#session.DSN#">
			insert into Clasificaciones ( Ecodigo, Ccodigo, Ccodigoclas, Cdescripcion, Cpath, Cnivel, Ccodigopadre, Ccomision, Ctexto, Cbanner, cuentac, CAid,Ctolerancia ,Creqcert, Cconsecutivo, Cformato,Ccuenta)
						values(  #session.Ecodigo# , 
								<cfqueryparam value="#consecutivo#" 	  cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Form.Ccodigoclas#"  cfsqltype="cf_sql_char">,
								<cfqueryparam value="#Form.CdescripcionCL#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#path#"			  cfsqltype="cf_sql_varchar" >,
								<cfqueryparam value="#nivel#"             cfsqltype="cf_sql_integer" >,
							<cfif isdefined("form.Ccodigopadre") and len(trim(form.Ccodigopadre))>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigopadre#">
							<cfelse>
							     <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">
							</cfif>,
								<cfqueryparam cfsqltype="cf_sql_float" value="#form.Ccomision#">,
							<cfif isdefined("form.Ctexto") and len(trim(form.Ctexto))>
							    <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.Ctexto#">
							<cfelse>
							     <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="null">
							</cfif>,
							<cfif isdefined("form.Cbanner") and len(trim(form.Cbanner))>
							    <cf_dbupload filefield="Cbanner" accept="image/*" datasource="#session.DSN#">
							<cfelse>
								 <cf_jdbcquery_param cfsqltype="cf_sql_blob" value="null">
						    </cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentac#">,
							<cfif isdefined("form.CAid") and len(trim(form.CAid))>
							    <cfqueryparam value="#Form.CAid#" cfsqltype="cf_sql_numeric">
						    <cfelse>
							    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						    </cfif>,
								<cfqueryparam cfsqltype="cf_sql_float" value="#form.Ctolerancia#">,
							<cfif isdefined("form.Creqcert")>
							    1
							<cfelse>
							    0
							</cfif>
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarCconsecutivo#" null="#LvarCconsecutivo eq 'null'#">,
							<cfif isdefined("form.Cmayor") and len(trim(form.Cmayor)) gt 0 and isdefined("form.Cformato") and len(trim(form.Cformato)) gt 0>
              		<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Cmayor) & "-" & trim(form.Cformato)#">,
              <cfelse>
              		null,
              </cfif>
							<cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric" null="#(!isdefined("form.Ccuenta") or (isdefined("form.Ccuenta") and len(trim(form.Ccuenta) eq 0)))#">
							)
		</cfquery>
		<cfset params = params & "?arbol_pos=#consecutivo#">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from Clasificaciones
			where Ecodigo =  #session.Ecodigo# 
			  and Ccodigo = <cfqueryparam value="#Form.Ccodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<cf_sifcomplementofinanciero action='delete' tabla="Clasificaciones" form = "form1" llave="#form.Ccodigo#" />
		
	<cfelseif isdefined("Form.EliminarImg")>
		<cfquery name="delete" datasource="#session.DSN#">
			update Clasificaciones 
			set Cbanner = 	<cf_jdbcquery_param cfsqltype="cf_sql_blob" value="null">
			where Ecodigo =  #session.Ecodigo# 
			  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
		</cfquery>
		<cfset params = params & "?arbol_pos=#form.Ccodigo#">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="Clasificaciones" 
			redirect="Clasificacion.cfm?arbol_pos=#form.Ccodigo#"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#Session.Ecodigo#"
			field2="Ccodigo,integer,#form.Ccodigo#">
					
		<cftransaction>
        	<cfset LvarCconsecutivo = "null">
			<cfif isDefined("Form.consecutivo") and Form.consecutivo GT 0>
                <cfset LvarCconsecutivo = Form.consecutivo>                
            </cfif>
            <cfquery name="update" datasource="#session.DSN#">
				update Clasificaciones 
				set Cdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CdescripcionCL#" >,
					Ccodigoclas  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ccodigoclas#" >,
					Cnivel       = <cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">,
					Cpath        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path#">,
					Ccodigopadre = <cfif isdefined("form.Ccodigopadre") and len(trim(form.Ccodigopadre))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigopadre#"><cfelse>null</cfif>,
					Ccomision    = <cfqueryparam cfsqltype="cf_sql_float"   value="#form.Ccomision#">,
					Ctolerancia  = <cfqueryparam cfsqltype="cf_sql_float"   value="#form.Ctolerancia#">,
					Creqcert     = <cfif isdefined("form.Creqcert")>1<cfelse>0</cfif>,
					Ctexto       = <cfif isdefined("form.Ctexto") and len(trim(form.Ctexto))>
					               <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.Ctexto#"><cfelse>null</cfif>
				<cfif isdefined("form.Cbanner") and len(trim(form.Cbanner))>
				   ,Cbanner      = <cf_dbupload filefield="Cbanner" accept="image/*" datasource="#session.DSN#">
				 </cfif>
				   ,cuentac      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentac#">,
				    CAid         = <cfif isdefined("form.CAid") and len(trim(form.CAid))><cfqueryparam value="#Form.CAid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>
                   ,Cconsecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarCconsecutivo#" null="#LvarCconsecutivo eq 'null'#">
				   ,Cformato = 
				   <cfif isdefined("form.Cmayor") and len(trim(form.Cmayor)) gt 0 and isdefined("form.Cformato") and len(trim(form.Cformato)) gt 0>
                        <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Cmayor) & "-" & trim(form.Cformato)#">
                   <cfelse>
                        null
                   </cfif>
                   ,Ccuenta		 = <cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_varchar">
				where Ecodigo =  #session.Ecodigo# 
				  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
			</cfquery>
			<cf_sifcomplementofinanciero action='update'
					tabla="Clasificaciones"
					form = "form1"
					llave="#form.Ccodigo#" />			
				
				<!--- Reordenamiento del arbolito --->	
				<!--- solo si cambia padre o codigo --->
				<cfif (form.Ccodigopadre neq form._Ccodigopadre) or (trim(form.Ccodigoclas) neq trim(form._Ccodigoclas)) >
	                <cfinclude template="../../Utiles/sifConcat.cfm">
					<cfquery name="update_path" datasource="#session.DSN#" >
						  update Clasificaciones
						  set Cpath =  right('*****' #_Cat# ltrim(rtrim(Ccodigoclas)), 5),
							  Cnivel = case when Ccodigopadre is null then 0 else -1 end
						  where Ecodigo = #session.Ecodigo#
					</cfquery>
	
					<cfset nivel  = 0 >	
					<cfloop from="0" to="99" index="i">
					<cfquery name="clasifica" datasource="#session.dsn#">
						select p.Cpath  as Cpath
							from Clasificaciones p inner join Clasificaciones c
							on p.Ccodigo = c.Ccodigopadre
							 and p.Ecodigo = c.Ecodigo
							 and p.Cnivel = #nivel#
					</cfquery>
					
					<cfquery datasource="#session.DSN#" >
						  	update Clasificaciones set 
								Cpath = '#clasifica.Cpath#'
								#_Cat#  '/' #_Cat# right ( '*****'  #_Cat#  rtrim(ltrim(Ccodigoclas)) , 5),
								Cnivel = #nivel + 1#
							where Ecodigo = #session.Ecodigo#
							  and Cnivel = -1	
					</cfquery>

						<cfquery datasource="#session.dsn#" name="rsSeguir">
							select count(1) as cantidad, max(Cdescripcion) as x
							from Clasificaciones 
							where Ecodigo= #session.Ecodigo# 
							  and Cnivel=-1
						</cfquery>
						
						<cfif rsSeguir.cantidad eq 0>
							<cfbreak>
						</cfif>
						<cfset nivel = nivel + 1 >
						
						<cfif nivel ge 100 >
							<cf_errorCode	code = "50002" msg = "La asociación no es válida">
						</cfif>
					</cfloop>
				</cfif><!--- reordenamiento --->

				<cfquery name="rsvalidar" datasource="#session.DSN#">
					select max(Cnivel) as nivelMaximo
					from Clasificaciones
					where Ecodigo= #session.Ecodigo# 
				</cfquery>
				
				<cfif rsvalidar.Recordcount gt 0 and len(trim(rsvalidar.nivelMaximo))>
					<cfif not _nivel(rsvalidar.nivelMaximo) >
						<cftransaction action="rollback">
						<cf_errorCode	code = "50043" msg = "Ha excedido el nivel máximo para la Clasificación de Artículos.">
					</cfif>
				</cfif>
			</cftransaction>
		<cfset params = params & "?arbol_pos=#form.Ccodigo#">
	</cfif>
</cfif>

<cfoutput>
<cflocation url="Clasificacion.cfm#params#">
</cfoutput>

