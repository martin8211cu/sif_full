<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<cftransaction>
<cfif isdefined("form.btnEliminar")>
	<cfloop list="#form.chk#" delimiters="," index="Lvar">
		<cfset LvarRHEAMid=#listgetat(Lvar, 1, ',')#>
         <cfquery name="delAcciones" datasource="#session.DSN#">
        	delete RHConceptosAccion
            from RHEmpleadosAccionMasiva a
            inner join RHAcciones b
            	on b.DEid = a.DEid
                and b.RHAid = a.RHAid
            inner join RHConceptosAccion c
            	on c.RHAlinea = b.RHAlinea
            where RHEAMid= #LvarRHEAMid#
              and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
        </cfquery> 	
         <cfquery name="delAcciones" datasource="#session.DSN#">
        	delete RHDAcciones
            from RHEmpleadosAccionMasiva a
            inner join RHAcciones b
            	on b.DEid = a.DEid
                and b.RHAid = a.RHAid
            inner join RHDAcciones c
            	on c.RHAlinea = b.RHAlinea
            where RHEAMid= #LvarRHEAMid#
              and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
        </cfquery> 
		<cfquery name="delAcciones" datasource="#session.DSN#">
        	delete RHAcciones 
            from RHEmpleadosAccionMasiva a
            inner join RHAcciones b
            	on b.DEid = a.DEid
                and b.RHAid = a.RHAid
            where RHEAMid= #LvarRHEAMid#
              and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
        </cfquery>
		<cfquery name="delAcciones" datasource="#session.dsn#">
				delete RHEmpleadosAccionMasiva 
				where RHEAMid= #LvarRHEAMid#
		</cfquery>
        
	</cfloop>
</cfif>
</cftransaction>

<cfif isdefined("Form.btnGenerar")>
<!---Como el boton de generar acciones puede ser presionado varias veces en caso de la anualidad se tendria que eliminar el detalle de anualidad creado y 
volver el encabezado a su forma original--->
	<cfquery name="rsDel" datasource="#session.dsn#">
		delete DAnualidad where RHAid=#Form.RHAid#
	</cfquery>
	<cfquery name="rsUpEn" datasource="#session.dsn#">
		select EAid,DEid from EAnualidad
		where DEid in (select DEid from RHEmpleadosAccionMasiva where RHAid=#Form.RHAid#)
		and EAacum < 345
	</cfquery>
	<cfloop query="rsUpEn">
	<cfquery name="rsUpA" datasource="#session.dsn#">
				update EAnualidad 
					set EAacum= (EAacum+360)
				where DEid =#rsUpEn.DEid#
				and DAtipoConcepto=2
			</cfquery>
	</cfloop>
	<cfquery name="Anua" datasource="#session.dsn#">
		select RHTAanualidad 
		from RHAccionesMasiva a
			inner join RHTAccionMasiva b
			on b.RHTAid=a.RHTAid
		where RHAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
	</cfquery>

    <cfif Anua.RHTAanualidad eq 1>
		<!---
		 3. Si tiene encabezado hay que actualizarlo
		 4. Crear el registro en el detalle de anualidades--->
		<cfquery name="rsDE" datasource="#session.dsn#">
			select DEid,RHAfhasta,RHAfdesde from RHEmpleadosAccionMasiva where RHAid=#Form.RHAid#
		</cfquery>
	
		<cfloop query="rsDE">
				<cfquery name="rsEnc" datasource="#session.dsn#">
					select EAid from EAnualidad where DEid=#rsDE.DEid# and DAtipoConcepto=2 <!---Concepto de anualidad tipo ITCR--->
				</cfquery>
				<cfquery name="rsIn" datasource="#session.dsn#">
					insert into DAnualidad(EAid,DAdescripcion,DAfdesde,DAfhasta,DAanos,BMfalta,BMUsucodigo,DAtipo,DAtipoConcepto,RHAid,DAaplicada)
					values(#rsEnc.EAid#,
							'Anualidad Cumplida',
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsDE.RHAfdesde#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsDE.RHAfhasta#">,
							1,
							#now()#,
							#session.Usucodigo#,
							1,
							2,
							#Form.RHAid#,0)
				</cfquery>	
				<cfquery name="rsUpA" datasource="#session.dsn#">
					update EAnualidad 
						set EAacum= (EAacum-360)
					where DEid =#rsDE.DEid#
					and DAtipoConcepto=2
				</cfquery>
		</cfloop>
<!---
	
	<cfquery name="rsUpA" datasource="#session.dsn#">
			update EAnualidad 
				   set EAtotal= (coalesce(EAtotal,0)+1),
				   EAacum= (EAacum-360)
			where DEid in (select DEid from RHEmpleadosAccionMasiva where RHAid=#Form.RHAid#)
			and DAtipoConcepto=2
	</cfquery>	--->
	</cfif>
	


<cfset tipoAplicacion = 0>
<cfif isdefined('form.chkTipoAplicacion')>
	<cfset tipoAplicacion = 1>
</cfif>
			
<cftransaction>
	
	<cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="generarAccionesMasivas" returnvariable="LvarResult">
		<cfinvokeargument name="RHAid" value="#Form.RHAid#"/>
		<cfinvokeargument name="RHTipoAplicacion" value="#tipoAplicacion#"/>
	</cfinvoke>

	<cfquery name="rsAccionMasiva" datasource="#Session.DSN#">
		select b.RHTAaplicaauto
		from RHAccionesMasiva a
			inner join RHTAccionMasiva b
				on b.RHTAid = a.RHTAid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
	</cfquery>

	<cfif rsAccionMasiva.RHTAaplicaauto EQ 1>
		<cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="aplicarAccionMasiva" returnvariable="LvarResult">
			<cfinvokeargument name="RHAid" value="#Form.RHAid#"/> 
		</cfinvoke>
		<cfset Form.paso = 0>

	<cfelse>
		<cfset Form.paso = 6>

	</cfif>
</cftransaction>	
</cfif>
