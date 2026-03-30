<cfif isdefined('form.ckDPen') and isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
	<cfquery name="rsPath" datasource="#session.DSN#">
		select CFpath
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.id_centro#">
	</cfquery>
</cfif>

<cfquery name="rsProc" datasource="#session.DSN#">
	<cfif not isdefined('form.ckDPen')>
		select a.RHUMid 
			,rtrim(c1.Pnombre || ' ' || rtrim(c1.Papellido1 || ' ' || c1.Papellido2)) as NombreUsuario 
			,d.CFdescripcion as Centro 
			,d.CFid
			,rtrim(g.DEnombre || ' ' || rtrim(g.DEapellido1 || ' ' || g.DEapellido2)) as NombreEmpleado 
			,RHCMfcapturada 
			,substring(convert(varchar,RHCMhoraentrada,108),1,5)as RHCMhoraentrada 
			,substring(convert(varchar,RHCMhorasalida,108),1,5) as RHCMhorasalida 
			,substring(convert(varchar,RHCMhoraentradac,108),1,5) as RHCMhoraentradac 
			,substring(convert(varchar,RHCMhorasalidac,108),1,5) as RHCMhorasalidac 
			,isnull(RHCMhorasrebajar,0) as RHCMhorasrebajar 
			,cia.Enombre as Enombre 
			,g.DEidentificacion as cedula 
			,d.CFdescripcion 
			,rhp.RHPdescripcion
			,rhpu.RHPdescpuesto 
			,RHCMhorasadicautor 
			,substring(h.RHASdescripcion,1,35) as RHASdescripcion 
			,e.RHPMfcierre 
		from DatosEmpleado g 
			,RHControlMarcas f 
			,RHProcesamientoMarcas e 
			,CFuncional d 
			,RHUsuariosMarcas a 
			,Usuario b1 
			,DatosPersonales c1
			,LineaTiempo lt 
			,RHAccionesSeguir h 
			,Empresa cia 
			,RHPlazas rhp 
			,RHPuestos rhpu
		where g.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
			and g.DEid in (<cfqueryparam cfsqltype="cf_sql_integer"  value="#form.DEid#">) --, 4839,4840)
		</cfif>
		<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
			and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.id_centro#">
		</cfif>
		
		<!---*********************---->
		<cfif isdefined("Form.fdesde") and len(trim(Form.fdesde)) and isdefined("Form.fhasta") and len(trim(Form.fhasta))>
			<cfif form.fdesde EQ form.fhasta>
				and f.RHCMfcapturada = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fdesde)#">
			<cfelseif form.fhasta LT form.fdesde>
				and f.RHCMfcapturada between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fhasta)#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fdesde)#">
			<cfelseif form.fdesde GT form.fhasta>
				and f.RHCMfcapturada between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fhasta)#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fdesde)#">
			</cfif>
		<cfelseif isdefined("Form.fdesde") and len(trim(Form.fdesde)) and not ( isdefined("Form.fhasta") and len(trim(Form.fhasta)))>
			and f.RHCMfcapturada >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fdesde)#">
		<cfelseif isdefined("Form.fhasta") and len(trim(Form.fhasta)) and not ( isdefined("Form.fdesde") and len(trim(Form.fdesde)) )>	
			and f.RHCMfcapturada <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fhasta)#">
		</cfif>				
		<!---*********************---->
		
			and f.DEid = g.DEid 
			and e.RHPMid = f.RHPMid 
			and e.RHPMusuarioInc = a.Usucodigo
			and d.CFid = e.CFid 
			and d.CFid = a.CFid 
			and getdate() between lt.LTdesde and lt.LThasta 
			and lt.DEid = g.DEid 
			and a.Usucodigo = b1.Usucodigo 
			and b1.datos_personales = c1.datos_personales 
			and h.RHASid =* f.RHASid	
			and cia.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.EcodigoSDC#">
			and rhp.RHPid = lt.RHPid 
			and lt.RHPcodigo = rhpu.RHPcodigo 
			and rhpu.Ecodigo = g.Ecodigo 
			and lt.Ecodigo = g.Ecodigo 
			order by 
			<cfif isdefined("form.ckCF")>
				Centro
			</cfif>
			<cfif isdefined("form.ckSP")>
				<cfif isdefined("form.ckCF")>
						,
				</cfif>
				NombreUsuario
			</cfif>
			<cfif isdefined("form.ckF")>
				<cfif isdefined("form.ckCF") or isdefined("form.ckSP")>
					,
				</cfif>
				NombreEmpleado
			</cfif>
			<cfif not isdefined("form.ckCF") and not isdefined("form.ckSP") and not isdefined("form.ckF")>
				Centro, NombreUsuario, NombreEmpleado
			</cfif>
			, RHCMfcapturada	
	<cfelse>
		select a.RHUMid 
			,rtrim(c1.Pnombre || ' ' || rtrim(c1.Papellido1 || ' ' || c1.Papellido2)) as NombreUsuario 
			,d.CFdescripcion as Centro 
			,d.CFid
			,rtrim(g.DEnombre || ' ' || rtrim(g.DEapellido1 || ' ' || g.DEapellido2)) as NombreEmpleado 
			,RHCMfcapturada 
			,substring(convert(varchar,RHCMhoraentrada,108),1,5)as RHCMhoraentrada 
			,substring(convert(varchar,RHCMhorasalida,108),1,5) as RHCMhorasalida 
			,substring(convert(varchar,RHCMhoraentradac,108),1,5) as RHCMhoraentradac 
			,substring(convert(varchar,RHCMhorasalidac,108),1,5) as RHCMhorasalidac 
			,isnull(RHCMhorasrebajar,0) as RHCMhorasrebajar 
			,cia.Enombre as Enombre 
			,g.DEidentificacion as cedula 
			,d.CFdescripcion 
			,rhp.RHPdescripcion
			,rhpu.RHPdescpuesto 
			,RHCMhorasadicautor 
			,substring(h.RHASdescripcion,1,35) as RHASdescripcion 
			,e.RHPMfcierre 
		from DatosEmpleado g 
			,RHControlMarcas f 
			,RHProcesamientoMarcas e 
			,CFuncional d 
			,RHUsuariosMarcas a 
			,Usuario b1 
			,DatosPersonales c1
			,LineaTiempo lt 
			,RHAccionesSeguir h 
			,Empresa cia 
			,RHPlazas rhp 
			,RHPuestos rhpu
		where g.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
			and g.DEid in (<cfqueryparam cfsqltype="cf_sql_integer"  value="#form.DEid#">)
		</cfif>
		<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
			and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.id_centro#">
		</cfif>
		<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) NEQ 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) NEQ 0>
			and f.RHCMfcapturada between <cfqueryparam cfsqltype="cf_sql_varchar"  value="#LSDateFormat(form.fdesde,'YYYYMMDD')#">
			and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(form.fhasta,'YYYYMMDD')#">
		</cfif>
			and f.DEid = g.DEid 
			and e.RHPMid = f.RHPMid 
			and e.RHPMusuarioInc = a.Usucodigo
			and d.CFid = e.CFid 
			and d.CFid = a.CFid 
			and getdate() between lt.LTdesde and lt.LThasta 
			and lt.DEid = g.DEid 
			and a.Usucodigo = b1.Usucodigo 
			and b1.datos_personales = c1.datos_personales 
			and h.RHASid =* f.RHASid	
			and cia.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.EcodigoSDC#">
			and rhp.RHPid = lt.RHPid 
			and lt.RHPcodigo = rhpu.RHPcodigo 
			and rhpu.Ecodigo = g.Ecodigo 
			and lt.Ecodigo = g.Ecodigo 
UNION

		select a.RHUMid 
			,rtrim(c1.Pnombre || ' ' || rtrim(c1.Papellido1 || ' ' || c1.Papellido2)) as NombreUsuario 
			,d.CFdescripcion as Centro 
			,d.CFid
			,rtrim(g.DEnombre || ' ' || rtrim(g.DEapellido1 || ' ' || g.DEapellido2)) as NombreEmpleado 
			,RHCMfcapturada 
			,substring(convert(varchar,RHCMhoraentrada,108),1,5)as RHCMhoraentrada 
			,substring(convert(varchar,RHCMhorasalida,108),1,5) as RHCMhorasalida 
			,substring(convert(varchar,RHCMhoraentradac,108),1,5) as RHCMhoraentradac 
			,substring(convert(varchar,RHCMhorasalidac,108),1,5) as RHCMhorasalidac 
			,isnull(RHCMhorasrebajar,0) as RHCMhorasrebajar 
			,cia.Enombre as Enombre 
			,g.DEidentificacion as cedula 
			,d.CFdescripcion 
			,rhp.RHPdescripcion
			,rhpu.RHPdescpuesto 
			,RHCMhorasadicautor 
			,substring(h.RHASdescripcion,1,35) as RHASdescripcion 
			,e.RHPMfcierre 
		from DatosEmpleado g 
			,RHControlMarcas f 
			,RHProcesamientoMarcas e 
			,CFuncional d 
			,RHUsuariosMarcas a 
			,Usuario b1 
			,DatosPersonales c1
			,LineaTiempo lt 
			,RHAccionesSeguir h 
			,Empresa cia 
			,RHPlazas rhp 
			,RHPuestos rhpu
		where g.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
			and g.DEid in (<cfqueryparam cfsqltype="cf_sql_integer"  value="#form.DEid#">)
		</cfif>
		<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) NEQ 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) NEQ 0>
			and f.RHCMfcapturada between <cfqueryparam cfsqltype="cf_sql_varchar"  value="#LSDateFormat(form.fdesde,'YYYYMMDD')#">
			and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(form.fhasta,'YYYYMMDD')#">
		</cfif>
 			<cfif isdefined('rsPath') and rsPath.recordCount GT 0 and rsPath.CFpath NEQ ''>
				and d.CFpath like '#rsPath.CFpath#/%'
			</cfif>
			and f.DEid = g.DEid 
			and e.RHPMid = f.RHPMid 
			and e.RHPMusuarioInc = a.Usucodigo
			and d.CFid = e.CFid 
			and d.CFid = a.CFid 
			and getdate() between lt.LTdesde and lt.LThasta 
			and lt.DEid = g.DEid 
			and a.Usucodigo = b1.Usucodigo 
			and b1.datos_personales = c1.datos_personales 
			and h.RHASid =* f.RHASid	
			and cia.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.EcodigoSDC#">
			and rhp.RHPid = lt.RHPid 
			and lt.RHPcodigo = rhpu.RHPcodigo 
			and rhpu.Ecodigo = g.Ecodigo 
			and lt.Ecodigo = g.Ecodigo 
			order by 
			<cfif isdefined("form.ckCF")>
				Centro
			</cfif>
			<cfif isdefined("form.ckSP")>
				<cfif isdefined("form.ckCF")>
						,
				</cfif>
				NombreUsuario
			</cfif>
			<cfif isdefined("form.ckF")>
				<cfif isdefined("form.ckCF") or isdefined("form.ckSP")>
					,
				</cfif>
				NombreEmpleado
			</cfif>
			<cfif not isdefined("form.ckCF") and not isdefined("form.ckSP") and not isdefined("form.ckF")>
				Centro, NombreUsuario, NombreEmpleado
			</cfif>
			, RHCMfcapturada		
	</cfif>
</cfquery>