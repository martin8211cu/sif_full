<cfcomponent>
	<cffunction name="fnSustituirMacros" returntype="string">
		<cfargument name="Definicion" 	type="string">
		<cfargument name="Tipo" 		type="numeric">
        <cfargument name="Aleas" 		type="string" default="#Arguments.Aleas#.">

	<cfif Arguments.Definicion EQ "[]">
		<cfset Arguments.Definicion = "">
	<cfelse>
		<!---<cfset Arguments.Definicion = replace(Arguments.Definicion,"[DES]", rsReporte.CPRdescripcion,"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[EMP]", rsEmpresa.Edescripcion,"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[EMPMAY]", ucase(rsEmpresa.Edescripcion),"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[]", " ","ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TIPOCTA]", "my.Ctipo","ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[CF]", LvarCF,"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[CFMAY]", ucase(LvarCF),"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TEMPORAL]", fnTemporal(),"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TIPOCUENTA]", fnTipoCta(),"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TIPOCUENTAMAY]", ucase(fnTipoCta()),"ALL")>

		<cfif isdefined("LvarRANGO_FEC")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[RANGO_FEC]", "(#LvarRANGO_FEC#)","ALL")>
		</cfif>
		<cfif isdefined("LvarRANGO_ANT")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[RANGO_ANT]", "(#LvarRANGO_ANT#)","ALL")>
		</cfif>
		<cfif isdefined("LvarMes")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MES]", LvarMes,"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESMAY]", fnNombreMes(LvarMes, true),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESMIN]", fnNombreMes(LvarMes, false),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ANO]", LvarAno,"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ANOANT]", LvarAno-1,"ALL")>
		</cfif>
--->	<cfif Arguments.Tipo EQ 3 OR Arguments.Tipo EQ 4 OR Arguments.Tipo EQ 5>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESINIMAY]", fnNombreMes(DatePart("m",rsPeriodo.CPPfechaDesde),true),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESINIMIN]", fnNombreMes(DatePart("m",rsPeriodo.CPPfechaDesde),false),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESFINMAY]", fnNombreMes(DatePart("m",rsPeriodo.CPPfechaHasta),true),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESFINMIN]", fnNombreMes(DatePart("m",rsPeriodo.CPPfechaHasta),false),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ANOINI]", DatePart("yyyy",rsPeriodo.CPPfechaDesde),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ANOFIN]", DatePart("yyyy",rsPeriodo.CPPfechaHasta),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[PER]", rsPeriodo.Pdescripcion,"ALL")>
		</cfif>
		<!---<cfset Arguments.Definicion = fnSutituirTipoDato(Arguments.Definicion,(Arguments.Tipo EQ 7 or Arguments.Tipo EQ 8))>--->
		<cfif Arguments.Tipo EQ 7 or Arguments.Tipo EQ 8>
			<!--- 
				Se sustituyen las SUPER MACROS por las formulas de MACROS
			--->
			<cfif find("[*",Arguments.Definicion) GT 0>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DCF]","([*PF]-[*PC])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DCP]","([*PP]-[*PC])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DCA]","([*PA]-[*PC])","ALL")>

				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DEF]","([*PF]-[ET])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DEP]","([*PP]-[ET])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DEA]","([*PA]-[ET])","ALL")>

				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DN]","([*PA]-[*PC]+[NP])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*PA]","([*PP]+[ME])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*PP]","([*PF]+[T]+[TE]+[VC])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*PF]","([A]+[M])","ALL")>

				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*PC]","([*PCA]+[RP])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*PCA]","([*RT]+[*CT]+[ET])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*RT]","([RA]+[RC])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*CT]","([CA]+[CC])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*FE]","([P]+[EJ])","ALL")>
			</cfif>
<!---
			<cfif Arguments.Tipo EQ 7>
				<!--- 
					Se sustituyen los MACROS utilizados en formulas por COLUMNAS del query
					Si se utilizan CAMPOS que no corresponden a COLUMNAS da error
					DATO : DIMENSION TEMPORAL·TITULO·EXPRESION
				--->
				<cfset LvarDatos = listToArray(Arguments.Definicion,"¦")>
				<cfloop index="d1" from="1" to="#arrayLen(LvarDatos)#">
					<cfset LvarDatosI = listToArray(LvarDatos[d1],"·")>
					<cfset LvarDato1 = LvarDatosI[3]>
					<cfif mid(LvarDato1,1,1) EQ "*" OR mid(LvarDato1,1,1) EQ "%">
						<cfloop index="d2" from="1" to="#arrayLen(LvarDatos)#">
							<cfif compare(d1, d2) NEQ 0>
								<cfset LvarDato2 = listGetAt(LvarDatos[d2],3,"·")>
								<cfif NOT (mid(LvarDato2,1,1) EQ "*" OR mid(LvarDato2,1,1) EQ "%")>
									<cfset LvarPto = find (LvarDato2,LvarDato1)>
									<cfloop condition="LvarPto GT 0">
										<cfset LvarDato1 	= mid(LvarDato1,1,LvarPto-1)
															& "Dato#d2#"
															& mid(LvarDato1,LvarPto+len(LvarDato2),4096)
										>
										<cfset LvarPto = find (LvarDato2,LvarDato1)>
									</cfloop>
								</cfif>
							</cfif>
						</cfloop>
						<cfset LvarPto = find("[",replace(replace(replace(LvarDato1,"[DATO","","ALL"),"[C","","ALL"),"[T","","ALL"))>
						<cfif LvarPto GT 0>
							<cf_errorCode	code = "50540"
											msg  = "Dato@errorDat_1@ es una formula que utiliza [MACROS] que no están como columnas:<BR>@errorDat_2@"
											errorDat_1="#d1#"
											errorDat_2="#LvarDato1#"
							>
						</cfif>
						<cfset LvarDatosI[3] = LvarDato1>
						<cfset LvarDatos[d1] = arrayToList(LvarDatosI,"·")>
					</cfif>
				</cfloop>
				<cfset Arguments.Definicion = arrayToList(LvarDatos,"¦")>
			</cfif>--->
			
			<!--- 
				Se sustituyen las MACROS por nombres de CAMPOS
			--->
			<!--- E1=Devengado=Ejecutado no Ejercido ni pagado=	si [EJ]<>0 then [ET]-[EJ] else [ET]-[P] --->
			<!--- E2=Ejercido=Ejercido no pagado=				si [EJ]<>0 then [EJ]-[P] else 0 --->
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[SGDB]", "case my.Cbalancen when 'D' then +1 else -1 end","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[SGCR]", "case my.Cbalancen when 'D' then -1 else +1 end","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[A]" ,"#Arguments.Aleas#.CPCpresupuestado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[M]" ,"#Arguments.Aleas#.CPCmodificado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[VC]","#Arguments.Aleas#.CPCvariacion","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ME]","#Arguments.Aleas#.CPCmodificacion_Excesos","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[T]" ,"#Arguments.Aleas#.CPCtrasladado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TE]","#Arguments.Aleas#.CPCtrasladadoE","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[RA]","#Arguments.Aleas#.CPCreservado_Anterior","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[CA]","#Arguments.Aleas#.CPCcomprometido_Anterior","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[RP]","#Arguments.Aleas#.CPCreservado_Presupuesto","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[RC]","#Arguments.Aleas#.CPCreservado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[CC]","#Arguments.Aleas#.CPCcomprometido","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[NP]","#Arguments.Aleas#.CPCnrpsPendientes","ALL")>

			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[E3]","case when [EJ]<>0 then [ET]-[EJ] else [ET]-[P] end","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[EJ3]","case when [EJ]<>0 then [EJ]-[P] else 0 end","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ET]" ,"([E]+[E2])","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[E]" ,"#Arguments.Aleas#.CPCejecutado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[E2]" ,"#Arguments.Aleas#.CPCejecutadoNC","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[P]" ,"#Arguments.Aleas#.CPCpagado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[EJ]","#Arguments.Aleas#.CPCejercido","ALL")>

			<cfset LvarPto1 = find("[C",Arguments.Definicion)>
			<cfloop condition="LvarPto1 GT 0">
				<cfset LvarPto2 = find("]",Arguments.Definicion, LvarPto1)>
				<cfset Arguments.Definicion = mid(Arguments.Definicion,1,LvarPto1-1) & "Dato" & mid(Arguments.Definicion,LvarPto1 + 2,LvarPto2-LvarPto1-2) & mid(Arguments.Definicion,LvarPto2+1,4096)>

				<cfset LvarPto1 = find("[C",Arguments.Definicion)>
			</cfloop>
		</cfif>
	</cfif>

	<cfreturn Arguments.Definicion>
	</cffunction>
</cfcomponent>