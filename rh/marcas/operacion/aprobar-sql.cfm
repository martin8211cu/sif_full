<cfinvoke key="MSG_YaEstaAplicadaLaMarca" default="Ya está Aplicada la marca"	 returnvariable="MSG_YaEstaAplicadaLaMarca" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_HayMarcasDuplicadas" default="Hay Marcas duplicadas. Favor verifique"	 returnvariable="MSG_HayMarcasDuplicadas" component="sif.Componentes.Translate" method="Translate"/>

<cfif isdefined("form.BOTON") and form.BOTON EQ 'Aplicar'>
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cfloop list="#form.chk#" index="i">			
			<!--- VERIFICA SI LA MARCA YA HA SIDO PROCESADA --->
			<cfquery name="VerificaMarcas" datasource="#session.DSN#">
				select a.CAMfdesde
				from RHCMCalculoAcumMarcas a
				inner join RHHControlMarcas b
					on b.DEid = a.DEid 
					and b.fechahoramarca = a.CAMfdesde
				where a.CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			<cfif VerificaMarcas.RecordCount>	
				<cf_throw message="#MSG_YaEstaAplicadaLaMarca#&nbsp;#LSDateFormat(VerificaMarcas.CAMfdesde,'dd/mm/yyyy h:mm:ss')#" errorcode="4025">
			<cfelse>
				<cfinvoke component="rh.Componentes.RH_ProcesoAplicaMarcas" method="RH_ProcesoAplicaMarcas" camid="#i#">
			</cfif>
		</cfloop>
	</cfif>
	<cflocation url="aprobar-lista.cfm">
</cfif>

<cfif isdefined("form.BOTON") and form.BOTON EQ 'Eliminar'>
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<!----Actualiza la tabla de marcas (RHControlMarcas) poner nulo el NumeroLote(es el CAMid de RHCMCalculoAcumMarcas)--->
		<cfquery datasource="#session.DSN#">
			update RHControlMarcas set numlote = null, grupomarcas = null, registroaut = 0
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ( numlote in (#form.chk#)
						or
					  numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="-1"><!---para poner como no procesadas las marcas que no debería porque el empleado no marca---->
					)
		</cfquery>
		<!---Eliminar registro ---->
		<cfquery datasource="#session.DSN#">
			delete from RHCMCalculoAcumMarcas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CAMid in (#form.chk#)
		</cfquery>
		</cfif>
			<cflocation url="aprobar-lista.cfm">
</cfif>