<!----Verificar que no se hayan insertado ya los datos---->
<cfquery name="rsExistePlazas" datasource="#session.DSNnuevo#">
	select 1 from RHPlazas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>

<cfif rsExistePlazas.RecordCount EQ 0>	
	<cfquery name="rsLineaTiempo" datasource="#session.DSNnuevo#"><!---Obtener la plaza de los empleados seleccionados en DATA---->
		select RHPid from LineaTiempo
		where Ecodigo = #vn_Ecodigo# 
			and getdate() between LTdesde and LThasta 
			<!---and DEid in (24680,24128,24540,24241,24042,24644,24803,24816,24986)--->
	</cfquery>
	
	<cfset vnRHPid = ValueList(rsLineaTiempo.RHPid)><!--Variable con las plazas que corresponden a los empleados seleccionados en DATA--->

	<cfquery name="rsPlazas" datasource="#session.DSNnuevo#"><!----Se traen las plazas que pertenecen a los empleados seleccionados en DATA---->
		select a.RHPid, a.CFid, b.CFcodigo, a.RHPpuesto, a.Dcodigo, a.Ocodigo, <!----a.RHTCid, a.Emp_Ecodigo,---->
			a.RHPdescripcion, a.RHPcodigo, a.CFidconta, a.RHPactiva
		from RHPlazas a
			inner join CFuncional b
				on a.Ecodigo = b.Ecodigo
				and a.CFid = b.CFid
		where <!----a.RHPid in (#PreserveSingleQuotes(vnRHPid)#)
			and----> a.Ecodigo = #vn_Ecodigo#
	</cfquery>
	
	<cfloop query="rsPlazas">
		<cfquery name="rsCFuncional" datasource="#session.DSNnuevo#"><!---Obtener el Identity del centro funcional en la nueva empresa---->
			select CFid from CFuncional
			where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPlazas.CFcodigo#">
		</cfquery>
	
		<cfif isdefined("rsCFuncional") and rsCFuncional.RecordCount NEQ 0>
			<cfquery datasource="#session.DSNnuevo#">
				insert into RHPlazas(Ecodigo, RHPpuesto, Dcodigo, Ocodigo, CFid, <!----RHTCid, 
									Emp_Ecodigo,-----> RHPdescripcion, RHPcodigo, CFidconta, RHPactiva, BMUsucodigo)	
				values(	<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.EcodigoNuevo#">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#rsPlazas.RHPpuesto#">,
						<cfif len(trim(rsPlazas.Dcodigo))><cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsPlazas.Dcodigo#"><cfelse>null</cfif>,
						<cfif len(trim(rsPlazas.Ocodigo))><cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsPlazas.Ocodigo#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsCFuncional.CFid#">,
						<!----<cfif len(trim(rsPlazas.RHTCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazas.RHTCid#"><cfelse>null</cfif>,
						<cfif len(trim(rsPlazas.Emp_Ecodigo))><cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsPlazas.Emp_Ecodigo#"><cfelse>null</cfif>,----->
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsPlazas.RHPdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#rsPlazas.RHPcodigo#">,
						<cfif len(trim(rsPlazas.CFidconta))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazas.CFidconta#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsPlazas.RHPactiva#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.UsucodigoNuevo#">
				)	
			</cfquery>
		</cfif>
	</cfloop>
	<!---Update de la plaza en CFuncional---->
	<cfquery name="rsCFuncional" datasource="#session.DSNnuevo#"><!---Obtiene todos los centros funcionales de la empresa DATA--->
		select a.RHPid, a.CFcodigo, b.RHPcodigo
		from CFuncional a
			left outer join RHPlazas b
				on a.Ecodigo = b.Ecodigo
				and a.RHPid = b.RHPid 
		where a.Ecodigo = #vn_Ecodigo#
			<!----and a.CFcodigo in ('01','02','03','04','05','06','124','119','128','114') --->
			and a.RHPid is not null	
	</cfquery>
	<cfloop query="rsCFuncional"><!---Para c/Cfuncional de la empresa DATA--->
		<cfquery name="rsRHPid" datasource="#session.DSNnuevo#"><!---Obtiene el RHPid(Identity) de la empresa nueva--->
			select RHPid from RHPlazas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.EcodigoNuevo#">
				and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCFuncional.RHPcodigo#">
		</cfquery>
		<cfif isdefined("rsRHPid") and rsRHPid.RecordCount NEQ 0><!---Si existe la plaza definida en la empresa nueva---->
			<cfquery datasource="#session.DSNnuevo#"><!---Realiza el update del campo RHPid (plaza)---->
				update CFuncional
				set RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHPid.RHPid#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.EcodigoNuevo#">
					and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCFuncional.CFcodigo#">
			</cfquery>
		</cfif>			
	</cfloop>
</cfif>

