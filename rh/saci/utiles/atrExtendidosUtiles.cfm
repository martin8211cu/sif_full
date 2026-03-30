<cfset campo="">
<cfset letra="">

<cfif isdefined("url.tipo") and isdefined("url.sufijo")>
	
	<cfif url.tipo EQ "1" or url.tipo EQ "2">											<!--- PERSONA-CLIENTE--->
		<cfset tabla ="ISBpersona">														<!--- Tabla de Persona--->
		<cfset tabla_relacion ="ISBpersonaAtributo">									<!--- Tabla de relacion entre atributo y persona--->
		<cfset campos_tabla="c.Aid, c.Aetiq, c.AtipoDato, b.PAvalor as valor">			<!--- Campos Requeridos: id del atributo, etiqueta, tipo de dato, valor contenido --->
		<cfset id_tabla="Pquien">														<!--- id de la persona --->												
		<cfif isdefined("url.tipo") and url.tipo eq "2">
			<cfset letra = "J_">															<!--- Letra para campos Juridicos --->
		<cfelseif isdefined("url.tipo") and url.tipo eq "1">
			<cfset letra = "F_">															<!--- Letra para campos Físicos --->
		</cfif>
		
	<cfelseif url.tipo EQ "3">															<!--- AGENTE --->
		<cfset tabla ="ISBagente">														<!--- Tabla de Agente--->
		<cfset tabla_relacion ="ISBagenteAtributo">										<!--- Tabla de relacion entre atributo y agente--->
		<cfset campos_tabla="c.Aid, c.Aetiq, c.AtipoDato, b.AAvalor as valor">			<!--- Campos Requeridos: id del atributo, etiqueta, tipo de dato, valor contenido --->
		<cfset id_tabla="AGid">															<!--- Id del Agente --->
		<cfset letra="A_">																<!--- Letra para campos de Agentes --->
	
	<cfelseif url.tipo EQ "4">															<!--- VENDEDOR-CUENTA --->
		<cfset tabla ="ISBcuenta">														<!--- Tabla de Cuenta--->
		<cfset tabla_relacion ="ISBcuentaAtributo">										<!--- Tabla de relacion entre atributo y cuenta--->
		<cfset campos_tabla="c.Aid, c.Aetiq, c.AtipoDato, b.VALOR as valor">			<!--- Campos Requeridos: id del atributo, etiqueta, tipo de dato, valor contenido --->
		<cfset id_tabla="CTid">															<!--- Id de la Cuenta --->		
		<cfset letra="C_">																<!--- Letra para campos de Cuenta --->
	</cfif>
	
	<cfif isdefined("url.id") and len(trim(url.id)) and url.id neq "-1">
		<cfquery datasource="#url.conexion#" name="rsValCampos">
			select #campos_tabla#			
			from #tabla# a
				left outer join ISBatributo c
					on c.Habilitado=1
				<cfif url.tipo EQ "1">
					and c.AapFisica=1
				<cfelseif url.tipo eq "2">
					and c.AapJuridica=1
				<cfelseif url.tipo EQ "3">
					and c.AapAgente=1
				<cfelseif url.tipo EQ "4">
					and c.AapCuenta=1
				</cfif>
				left outer join #tabla_relacion# b
				on a.#id_tabla# = b.#id_tabla#
				and c.Aid=b.Aid
			where a.#id_tabla# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#val(url.id)#">
			order by c.Aorden
		</cfquery>
		
	<cfelse>
		<cfquery datasource="#url.conexion#" name="rsValCampos">
			select c.Aid, c.Aetiq, c.AtipoDato, '' as valor
			from ISBatributo c
			where c.Habilitado=1
			<cfif url.tipo EQ "1">
				and c.AapFisica=1
			<cfelseif url.tipo eq "2">
				and c.AapJuridica=1
			<cfelseif url.tipo EQ "3">
				and c.AapAgente=1
			<cfelseif url.tipo EQ "4">
				and c.AapCuenta=1
			</cfif>
			order by c.Aorden
		</cfquery>

	</cfif>
	
	<cfoutput>
	<cfif rsValCampos.recordcount gt 0 and isdefined("rsValCampos.Aid") and len(trim(rsValCampos.Aid))>
		<script language="JavaScript">
			<cfloop query="rsValCampos">
				<cfset campo = letra & rsValCampos.Aid & Trim(url.sufijo)>							<!--- Define el nombre del campo en el que va a refrescar el valor  --->
				window.parent.document.#url.form_name#.#campo#.value = '#rsValCampos.valor#';
			</cfloop>	
		</script>
			
	</cfif>
	</cfoutput>
	
</cfif>	

