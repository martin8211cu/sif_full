<cfinclude template="anexo-validar-permiso.cfm">
<cfset anexolk = 0>
<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("form.CtaFinal") and len(Trim(form.CtaFinal)) eq 0>
	
		<script language="JavaScript">
			mensaje = "El formato de la cuenta es inválido. Por favor espere a que \n se desplieguen los niveles de la cuenta"
			alert(mensaje)
			history.back()
		</script>
		<cfabort>
	</cfif>

	<cfif not isdefined("Form.BAJA")>

		<cfset formato = " ">
		<cfset movimientos = "N">
		<cfset LvarPCDcatid = "">
			
		<cfif isdefined("form.CtaFinal") and len(trim(form.CtaFinal))>
			<!--- Se le da formato a la máscara --->
			<cfquery name="rsCPV" datasource="#Session.DSN#">
				select v.CPVformatoF
				  from CPVigencia v
				 where v.Ecodigo = #session.Ecodigo# 
				   and v.Cmayor	= '#form.txt_Cmayor#'
				   and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between CPVdesde and CPVhasta
			</cfquery>
			<cfset formato1 = trim(replace(form.CtaFinal,"-","","ALL"))>
			<cfset formato1N= len(formato1)>

			<cfset formato	= "">
			<cfset LvarCPVfmt	= trim(rsCPV.CPVformatoF)>
			<cfset LvarCPVfmtN	= len(LvarCPVfmt)>
			<cfset j = 0>
			<cfloop index="i" from="1" to="#LvarCPVfmtN#">
				<cfif mid(LvarCPVfmt,i,1) EQ "-">
					<cfset formato = formato & "-">
				<cfelseif j LT formato1N>
					<cfset j=j+1>
					<cfset formato = formato & mid(formato1,j,1)>
				<cfelse>
					<cfset formato = formato & "_">
				</cfif>
			</cfloop>
		</cfif>
			
		<cfif isdefined("Form.AnexoCelMov") OR (form.AnexoCon GTE 50 and form.AnexoCon LTE 69)>
			<!--- Obtener hijas que aceptan movimientos: cuando son cuentas de Control/Formulacion de Presupuesto se fuerza --->
			<cfset movimientos = "S">
			<cfset anexolk = 1>

			<!--- Se hace un 'rtrim' pero de ('-','_') y se le incluye un '% al final (movs=true) --->
			<cfset formato = fnRQuitar (formato, true)>
		<cfelse>
			<!--- NO Obtener hijas que aceptan movimientos --->

			<!--- Se hace un 'rtrim' pero de ('-','_') excepto los '_' en ultimo nivel (movs=false) --->
			<cfset formato = fnRQuitar (formato, false)>

			<!--- NO Obtener hijas que aceptan movimientos --->

			<!--- 
				Buscar y redefinir el campo anexolk - en caso de que se determine el catálogo final de la cuenta -
				Solamente aplica cuando no se adiciona el "%" al final del formato, porque se busca el valor en 
				la cuenta contable asignada
				1. Obtener la cuenta de mayor
				2. Buscar la máscara de la cuenta
				3. Buscar el último valor definido en la máscara ( formato ) de la cuenta definida
				4. Si el último valor definido en la máscara corresponde a un catálogo independiente:
				4.1   Colocar el campo anexolk en un valor 2
				4.2   Buscar el valor del catálogo para grabarlo en el campo PCDcatid
			--->
			<cfset rst = find("_",formato,1)>
			<cfif rst gt 0>
				<cfset anexolk = 1>
				<cfset LvarCuentaMayor = form.txt_Cmayor>
				<cfquery name="rsMascara" datasource="#Session.DSN#">
					select v.PCEMid
					  from CPVigencia v
					 where v.Ecodigo = #session.Ecodigo# 
					   and v.Cmayor	= '#LvarCuentaMayor#'
					   and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between CPVdesde and CPVhasta
				</cfquery>

				<cfif rsMascara.recordcount GT 0 and trim(rsMascara.PCEMid) NEQ "">
					<cfquery name="rsPosicionMascara" datasource="#Session.DSN#">
						select 
							a.PCNid as Nivel,
							a.PCEcatid as PCEcatid, 
							a.PCNdep as Depende, 
							5 + PCNid + coalesce((
								select sum(PCNlongitud)
								from PCNivelMascara b
								where b.PCEMid = a.PCEMid
								  and b.PCNid  < a.PCNid), 0)
							as PosicionInicial,
							a.PCNlongitud as Longitud,
							4 + a.PCNlongitud + PCNid + coalesce((
								select sum(PCNlongitud)
								from PCNivelMascara b
								where b.PCEMid = a.PCEMid
								  and b.PCNid  < a.PCNid), 0)
							as PosicionFinal
						from PCNivelMascara a
						where a.PCEMid = #rsMascara.PCEMid#
						order by a.PCNid
					</cfquery>
	
					<cfset LvarValorCatalogo = "">
					<cfset LvarPosicionCatalogo = len(formato)> 
	
					<cfloop condition="LvarPosicionCatalogo GT 5">
						<cfif mid(formato, LvarPosicionCatalogo, 1) NEQ '-' and mid(formato, LvarPosicionCatalogo, 1) NEQ '_' and mid(formato, LvarPosicionCatalogo, 1) NEQ ' '>
							<cfset LvarValorCatalogo = mid(formato, LvarPosicionCatalogo, 1) & LvarValorCatalogo>
						<cfelse>
							<cfset LvarPosicionCatalogo = LvarPosicionCatalogo + 1>
							<cfbreak>
						</cfif>
						<cfif LvarPosicionCatalogo EQ 5>
							<cfset LvarPosicionCatalogo = 0>
							<cfbreak>
						</cfif>
						<cfset LvarPosicionCatalogo = LvarPosicionCatalogo - 1>
					</cfloop>
					
					<cfquery dbtype="query" name="rsPosicionMascaraNivel">
						select *
						from rsPosicionMascara
						where PosicionInicial = #LvarPosicionCatalogo#
						  and Longitud = #len(LvarValorCatalogo)#
					</cfquery> 
					
					<cfif rsPosicionMascaraNivel.recordcount EQ 1 and len(rsPosicionMascaraNivel.PCEcatid) GT 0 and len(rsPosicionMascaraNivel.Depende) EQ 0>
	
						<!--- Buscar el Valor del Catálogo Correspondiente --->
						<cfquery name="rsPCDcatid" datasource="#Session.DSN#">
							select PCDcatid
							from PCDCatalogo
							where PCEcatid = #rsPosicionMascaraNivel.PCEcatid#
							  and PCDvalor = '#LvarValorCatalogo#'
							  and (Ecodigo is null or Ecodigo = #session.Ecodigo#)
						</cfquery>
						<cfif rsPCDcatid.recordcount EQ 1>
							<cfset LvarPCDcatid = rsPCDcatid.PCDcatid>
							<cfset anexolk = 2>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfif>

	<cfif isdefined("Form.ALTA")>
		<cfquery name="AnexoCelD_ABC" datasource="#Session.DSN#">
			insert into AnexoCelD (Ecodigo, AnexoCelId, AnexoCelFmt, AnexoCelMov, AnexoSigno, Anexolk, Cmayor, PCDcatid)
			values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#formato#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#movimientos#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.AnexoSigno#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#anexolk#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txt_Cmayor#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPCDcatid#" null="#len(lvarPCDcatid) eq 0#">
				  )
		</cfquery>
		<cfset modo = "ALTA">
		
	<cfelseif isdefined("Form.CAMBIO")>
		<cfquery name="AnexoCelD_ABC" datasource="#Session.DSN#">
			update AnexoCelD set 
				AnexoCelFmt   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#formato#">,
				AnexoCelMov   = <cfqueryparam cfsqltype="cf_sql_char" value="#movimientos#">,
				AnexoSigno    = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AnexoSigno#">,
				Anexolk		  = <cfqueryparam cfsqltype="cf_sql_integer" value="#anexolk#">,	
				Cmayor 		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txt_Cmayor#">,
				PCDcatid	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPCDcatid#" null="#len(lvarPCDcatid) eq 0#">
			where AnexoCelDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelDid#">
		</cfquery>

		<cfset modo = "CAMBIO">
		
	<cfelseif isdefined("Form.BAJA")>
		
		<cfquery name="AnexoCelD_ABC" datasource="#Session.DSN#">
			delete from AnexoCelD
			where AnexoCelDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelDid#">
			<cfset modo = "ALTA">
		</cfquery>
		
	</cfif>
</cfif>

<cfset fltr = "&nav=1">
<cfif isdefined("form.F_Hoja") and len(trim(form.F_Hoja)) gt 0>
	<cfset fltr = fltr & "&F_Hoja=#form.F_Hoja#">
</cfif>
<cfif isdefined("form.F_columna") and form.F_columna gt 0>
	<cfset fltr = fltr & "&F_columna=#form.F_columna#">
</cfif>
<cfif isdefined("form.F_fila") and form.F_fila gt 0>
	<cfset fltr = fltr & "&F_fila=#form.F_fila#">
</cfif>
<cfif isdefined("form.F_Rango") and len(trim(form.F_Rango)) gt 0>
	<cfset fltr = fltr & "&F_Rango=#form.F_Rango#">
</cfif>				
<cfif isdefined("form.F_Estado") and form.F_Estado gt 0>
	<cfset fltr = fltr & "&F_Estado=#form.F_Estado#">
</cfif>
<cfif isdefined("form.F_Cuentas") and form.F_Cuentas gt -1>
	<cfset fltr = fltr & "&F_Cuentas=#form.F_Cuentas#">
</cfif>

<cfset pagina = "">
<cfif isdefined("form.Ppagina")>
	<cfset pagina = "&Ppagina=#form.Ppagina#">
</cfif>
<cflocation url="anexo.cfm?tab=2&cta=1&AnexoId=#Form.AnexoId#&AnexoCelId=#Form.AnexoCelId##pagina##fltr#">

<cfquery name="rsLinea" datasource="#Session.DSN#">
	select c.Cmayor, c.AnexoCelDid, c.AnexoCelFmt, c.AnexoCelMov, c.Anexolk, v.CPVformatoF
	  from AnexoCelD c
		inner join CPVigencia v
		 on v.Ecodigo	= c.Ecodigo
		and v.Cmayor	= c.Cmayor
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between CPVdesde and CPVhasta
	where c.AnexoCelMov = 'N'
	  and right(rtrim(AnexoCelFmt),1) in ('_','%')
</cfquery>
<cfloop query="rsLinea">
	<cfset movimientos = "N">
	<cfset LvarPCDcatid = "">

	<cfset formato1	= ListToArray(rsLinea.AnexoCelFmt, '%')>
	<cfset formato1	= trim(replace(formato1[1],"-","","ALL"))>
	<cfset formato1N= len(formato1)>
	<cfset formato	= "">
	<cfset LvarCPVfmt	= trim(rsLinea.CPVformatoF)>
	<cfset LvarCPVfmtN	= len(LvarCPVfmt)>
	<cfset j = 0>
	<cfloop index="i" from="1" to="#LvarCPVfmtN#">
		<cfif mid(LvarCPVfmt,i,1) EQ "-">
			<cfset formato = formato & "-">
		<cfelseif j LT formato1N>
			<cfset j=j+1>
			<cfset formato = formato & mid(formato1,j,1)>
		<cfelse>
			<cfset formato = formato & "_">
		</cfif>
	</cfloop>
	
	<!--- Se hace un 'rtrim' pero de ('-','_') excepto los '_' en ultimo nivel (movs=false) --->
	<cfset formato = fnRQuitar (formato, false)>
	<cfif rsLinea.AnexoCelFmt NEQ formato>
		<cfquery  datasource="#Session.DSN#">
			update AnexoCelD
			   set AnexoCelFmt = '#formato#'
			 where AnexoCelDid = #rsLinea.AnexoCelDid#
		</cfquery>
	</cfif>
</cfloop>

<cffunction name="fnRQuitar" returntype="string" output="false">
	<cfargument name="Formato"	type="string"	required="yes">
	<cfargument name="Movs"		type="boolean"	required="yes">
	<cfset var i			= 0>
	<cfset var LvarFormato	= rtrim(Arguments.formato)>
	<cfset var u			= 0>
	<cfset var LvarChar		= "">

	<!--- Se se quitan los '%' y blancos intermedios --->
	<cfset LvarFormato = REreplace(LvarFormato,"[% ]","_","ALL")>
	<cfloop index="i" from="#len(LvarFormato)#" to="1" step="-1">
		<cfset LvarChar = mid(LvarFormato,i,1)>
		<cfif LvarChar EQ "-">
			<cfset u = i>
		</cfif>
		<cfif not Find(LvarChar, "-_")>
			<cfif Arguments.Movs>
				<cfset LvarFormato = mid(LvarFormato,1,i) & "%">
			<cfelseif u GT 0>
				<cfset LvarFormato = mid(LvarFormato,1,u-1)>
			<cfelse>
				<cfset LvarFormato = LvarFormato>
			</cfif>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfreturn LvarFormato>
</cffunction>

