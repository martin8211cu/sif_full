<cfquery name="rsExisteCFuncional" datasource="#session.DSNnuevo#"><!---Verificar si ya existe el centro funcional----->
	select 1 from CFuncional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">			
</cfquery>
<cfif isdefined("rsExisteCFuncional") and rsExisteCFuncional.RecordCount EQ 0><!---Si no existe ya el centro funcional--->
	<!----1. Inserta en CFuncional--->
	<cfquery name="t" datasource="#session.DSNnuevo#">		
		insert into CFuncional(Ecodigo, CFcodigo, Dcodigo, Ocodigo, RHPid, CFdescripcion, CFidresp, CFcuentac, 
					CFcuentaaf, CFuresponsable, CFcomprador, CFpath, CFnivel, CFcorporativo, CFcuentainversion, 
					CFcuentainventario, BMUsucodigo, CFcuentaingreso)
				
			select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> as Ecodigo,
				CFcodigo, Dcodigo, Ocodigo, null as RHPid, CFdescripcion, null as CFidresp, CFcuentac, CFcuentaaf, CFuresponsable,
				CFcomprador, CFpath, CFnivel, CFcorporativo, CFcuentainversion, CFcuentainventario, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#"> as BMUsucodigo, CFcuentaingreso
			from CFuncional 
			where Ecodigo = #vn_Ecodigo#
				<!---and CFcodigo in ('01','02','03','04','05','06','124','119','128','114') 	--->
	</cfquery>	
	<!----2. Actualizar campo CFidresp---->
	<cfquery name="CFuncionales" datasource="#session.DSNnuevo#"><!----Centros funcionales insertados en la nueva cia---->
		select CFcodigo, CFid from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">			
	</cfquery>

	<cfloop query="CFuncionales"><!---para c/centro funcional insertado en la nueva empresa---->
		<cfset vsCFcodigo = CFuncionales.CFcodigo><!---Variable con el codigo del centro funcional (CFcodigo)---->
		<cfquery name="rsId" datasource="#session.DSNnuevo#"><!---Traer el CFuncional resposable en DATA---->
			select CFidresp from CFuncional 
			where Ecodigo = #vn_Ecodigo#
				and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vsCFcodigo#">
		</cfquery>
		<cfif isdefined("rsId") and len(trim(rsId.CFidresp))><!---Si tiene asignado un CFuncional responsable--->
			<cfquery name="rsResponsable" datasource="#session.DSNnuevo#"><!---Trae el CFcodigo del CFuncional de DATA---->
				select CFcodigo from CFuncional
				where Ecodigo = #vn_Ecodigo#
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsId.CFidresp#">
			</cfquery>
			<cfif isdefined("rsResponsable") and len(trim(rsResponsable.CFcodigo))><!---Si existe el CFuncional responsable en la nueva empresa---->
				<cfquery name="rsCF" datasource="#session.DSNnuevo#"><!---Traer el ID del CFuncional en nueva empresa---->
					select CFid from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
						and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsResponsable.CFcodigo#">
				</cfquery>
				<cfif isdefined("rsCF") and len(trim(rsCF.CFid))><!--Si existe el ctro funcional en la empresa nueva----->
					<cfquery datasource="#session.DSNnuevo#">
						update CFuncional
						set CFidresp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCF.CFid#">
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
							and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vsCFcodigo#">
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	<!---3. Actualizar RHPuestos---->
	<cfquery name="rsEnPuestos" datasource="#session.DSNnuevo#"><!---Traer todos los puestos de la empresa DATA y la descripcion del CFuncional asignado (solo los que tienen uno asignado)---->
		select a.CFid, b.CFcodigo, RHPcodigo 
		from RHPuestos a		
			left outer join CFuncional b
				on a.Ecodigo = b.Ecodigo
				and a.CFid = b.CFid
		where a.Ecodigo = #vn_Ecodigo# 
			<!---and a.RHPcodigo in ('0015','0002','0003','0011','0010','GC4841','4567','0008')--->
			and a.CFid is not null
	</cfquery>
	<cfloop query="rsEnPuestos"><!---Para c/puesto con un CFid asignado---->
		<cfquery name="rsCFid" datasource="#session.DSNnuevo#"><!---- Obtiener el CFid correspondiente en la nueva empresa----->
			select CFid from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEnPuestos.CFcodigo#">				
		</cfquery>
		<cfif isdefined("rsCFid") and rsCFid.RecordCount NEQ 0><!---Si existe el CFuncional en la nueva empresa---->
			<cfquery datasource="#session.DSNnuevo#"><!-----Realizar el update del CFid correspondiente---->
				update RHPuestos 
				set CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFid.CFid#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEnPuestos.RHPcodigo#">
			</cfquery>			
		</cfif>
	</cfloop>
</cfif>
