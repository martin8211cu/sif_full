<!---Botones de Regresar--->
<cfif isdefined ('form.reg')>
	<cflocation url="ListaDetalles.cfm?PCCEclaid=#form.PCCEclaid#&smes=#form.smes#&speriodo=#form.speriodo#">
		<cfreturn>
</cfif>
<cfif isdefined ('form.reg2')>
	<cflocation url="PorcentajesOficinas.cfm?smes=#form.smes#&speriodo=#form.speriodo#">
		<cfreturn>
</cfif>
<cfif isdefined ('form.reg3')>
	<cflocation url="PorcentajesOficinas.cfm">
		<cfreturn>
</cfif>
<cfif isdefined ('form.regI')>
	<cflocation url="formPorcentajesOficinas.cfm?PCCEclaid=#form.PCCEclaid#&smes=#form.smes#&speriodo=#form.speriodo#&PCCDclaid=#form.PCCDclaid#">
		<cfreturn>
</cfif>

<!---Importador--->
<cfif isdefined ("form.Importar")>
	<cflocation url="Importa_porcentaje_oficinas.cfm?&speriodo=#form.speriodo#&smes=#form.smes#&PCCDclaid=#form.PCCDclaid#&PCCEclaid=#form.PCCEclaid#" addtoken="no">
		<cfreturn>
</cfif>

<!---Grabar Porcentajes de Oficina--->
<cfif isdefined ('form.grabar')>
	<cfquery name="rsOfi" datasource="#session.dsn#">
		select Ocodigo from Oficinas where Ecodigo=#session.Ecodigo#
	</cfquery>
		
	<cfset porc = 0.00>
	<cfloop query="rsOfi">
		<cfset LvarOfi="form.Ovalor_#rsOfi.Ocodigo#">			
			<cfif isdefined(LvarOfi)>
				<cfset LvarOvalor = form["Ovalor_#rsOfi.Ocodigo#"]>		
			<cfelse>
				<cfset LvarOvalor = 0>
			</cfif>
			
			<cfif LvarOvalor NEQ 0>
				<cfset porc=porc+LvarOvalor>
			</cfif>
	</cfloop>

	<cfif porc eq 0>
		<cf_errorCode	code = "50229" msg = "Proceso Cancelado: La suma de los porcentajes no puede ser cero(0)">
	</cfif>
	
	<cfif porc gte 100.01>
		<cf_errorCode	code = "50230"
						msg  = "Proceso Cancelado: La suma de los porcentajes no puede ser mayor que cien(100). Esta generando @errorDat_1@%"
						errorDat_1="#porc#"
		>
	</cfif>
	
	<cfif porc lt 100>
		<cf_errorCode	code = "50231" msg = "Proceso Cancelado: La suma de los porcentajes no puede ser menor que cien(100)">
	</cfif>	

	<cfif porc eq 100>	
		<cfloop query="rsOfi">
			<cfset LvarOfi="form.Ovalor_#rsOfi.Ocodigo#">			
				<cfif isdefined(LvarOfi)>
					<cfset LvarOvalor = form["Ovalor_#rsOfi.Ocodigo#"]>		
				<cfelse>
					<cfset LvarOvalor = 0>
				</cfif>
				
			<cfif LvarOvalor neq 0>		
				<cfquery name="slOxC" datasource="#session.dsn#">
					select count(1) as cantidad from OficinasxClasificacion where
					PCCDclaid=#form.PCCDclaid#
					and CGCperiodo=#form.speriodo#
					and CGCmes=#form.smes#
					and Ocodigo=#rsOfi.Ocodigo#
				</cfquery>
				
				<cfif slOxC.cantidad gt 0>
					<cfquery name="upOxC" datasource="#session.dsn#">
						update OficinasxClasificacion set CGCporcentaje=#LvarOvalor#
						where
							PCCDclaid=#form.PCCDclaid#
							and CGCperiodo=#form.speriodo#
							and CGCmes=#form.smes#
							and Ocodigo=#rsOfi.Ocodigo#
					</cfquery>
				<cfelse>
					<cfquery name="inOxC" datasource="#session.dsn#">
						insert into OficinasxClasificacion(
							PCCDclaid,
							PCDcatid,
							CGCperiodo,
							CGCmes,
							Ocodigo,
							CGCporcentaje,
							Ecodigo)
						values
							(
							#form.PCCDclaid#,
							null,
							#form.speriodo#,
							#form.smes#,
							#rsOfi.Ocodigo#,
							#LvarOvalor#,
							#session.Ecodigo#
							)
					</cfquery>	
				</cfif>
				<cfelse>
					<cfquery name="slOxC" datasource="#session.dsn#">
						select count(1) as cantidad from OficinasxClasificacion where
						PCCDclaid=#form.PCCDclaid#
						and CGCperiodo=#form.speriodo#
						and CGCmes=#form.smes#
						and Ocodigo=#rsOfi.Ocodigo#
					</cfquery>
					
					<cfif slOxC.cantidad gt 0>
						<cfquery name="upOxC" datasource="#session.dsn#">
							delete from OficinasxClasificacion 
							where
								PCCDclaid=#form.PCCDclaid#
								and CGCperiodo=#form.speriodo#
								and CGCmes=#form.smes#
								and Ocodigo=#rsOfi.Ocodigo#
						</cfquery>
			 	  </cfif>
			   </cfif>
		</cfloop>
	</cfif>
	<cflocation url="formPorcentajesOficinas.cfm?PCCDclaid=#form.PCCDclaid#&PCCEclaid=#form.PCCEclaid#&smes=#form.smes#&speriodo=#form.speriodo#">
		<cfreturn>
</cfif>

<!---Copia de valores en el detalle--->
<cfif isdefined('form.copiar')>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select * from OficinasxClasificacion where CGCmes=#form.mes# and CGCperiodo=#form.periodo#
		and PCCDclaid=#form.PCCDclaid#
	</cfquery>
	<cfif rsSQL.recordcount eq 0>
		<cflocation url="CopiaPorcentaje.cfm?bandera=1&periodo=#form.periodo#&mes=#form.mes#&smes=#form.smes#&speriodo=#form.speriodo#&PCCDclaid=#form.PCCDclaid#&PCCEclaid=#form.PCCEclaid#">
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select * from OficinasxClasificacion where CGCmes=#form.smes# and CGCperiodo=#form.speriodo#
			and PCCDclaid=#form.PCCDclaid#
		</cfquery>
			<cfif rsSQL.recordcount eq 0>
				<cfquery name="rsIns" datasource="#session.dsn#">
					insert into OficinasxClasificacion(
						PCCDclaid,
						PCDcatid,
						CGCperiodo,
						CGCmes,
						Ocodigo,
						CGCporcentaje,
						Ecodigo)
					select PCCDclaid,
					PCDcatid,
					#form.speriodo#,
					#form.smes#,
					Ocodigo,
					CGCporcentaje,
					Ecodigo
						from OficinasxClasificacion
					where CGCmes=#form.mes# and CGCperiodo=#form.periodo# and PCCDclaid=#form.PCCDclaid#
				</cfquery>
			<script language="JavaScript1.2">
				if (window.opener.funcfiltro) {window.opener.funcfiltro()}
				window.close();
			</script>
		<cfelse>
			<cflocation url="CopiaPorcentaje.cfm?bandera2=2&periodo=#form.periodo#&mes=#form.mes#&smes=#form.smes#&speriodo=#form.speriodo#&PCCDclaid=#form.PCCDclaid#&PCCEclaid=#form.PCCEclaid#">
		</cfif>
	</cfif>
		<cfreturn>
</cfif>

<!---Sobreescribir valores en la copia--->
<cfif isdefined ('form.sobre')>
	<cfquery name="dlSQL" datasource="#session.dsn#">
		delete from OficinasxClasificacion where CGCmes=#form.smes# and CGCperiodo=#form.speriodo#
		and PCCDclaid=#form.PCCDclaid#
	</cfquery>
	<cfquery name="rsIns" datasource="#session.dsn#">
					insert into OficinasxClasificacion(
						PCCDclaid,
						PCDcatid,
						CGCperiodo,
						CGCmes,
						Ocodigo,
						CGCporcentaje,
						Ecodigo)
					select PCCDclaid,
					PCDcatid,
					#form.speriodo#,
					#form.smes#,
					Ocodigo,
					CGCporcentaje,
					Ecodigo
						from OficinasxClasificacion
					where CGCmes=#form.mes# and CGCperiodo=#form.periodo# and PCCDclaid=#form.PCCDclaid#
				</cfquery>
			<script language="JavaScript1.2">
				if (window.opener.funcfiltro) {window.opener.funcfiltro()}
				window.close();
			</script>
		<cfreturn>
</cfif>

<!---Copia de valores de Oficina en el encabezado--->
<cfif isdefined ('form.cvt')>
<cfset variablecopia=0><!---existen valores para copiar-SQL--->
<cfset variablesobre=0><!---existen valores para sobrescribir-SQL1--->
<!---#form.params# corresponde al PCCDclaid--->	

<cfloop list="#form.params#" delimiters="," index="aa">
		<cfset valor=#listgetat(aa, 1, ',')#>
		
			<cfquery name="rsSQL" datasource="#session.dsn#"><!---para ver si existen valores para copiar--->
				select 
					o.PCCDclaid,
					o.PCDcatid,
					o.CGCperiodo,
					o.CGCmes,
					o.Ocodigo,
					o.CGCporcentaje,
					o.Ecodigo
				from PCClasificacionE e
					inner join PCClasificacionD d
						inner join OficinasxClasificacion o
						on o.PCCDclaid=d.PCCDclaid
					on  e.PCCEclaid=d.PCCEclaid	
				where e.PCCEclaid=#form.PCCEclaid#
				and o.CGCperiodo =#form.periodo# 
				and o.CGCmes=#form.mes#
				and o.PCCDclaid=#valor#
			</cfquery>
			
		<cfif rsSQL.recordcount gt 0>
				<cfset variablecopia=variablecopia+1>
		</cfif>
			
		<cfquery name="rsSQL1" datasource="#session.dsn#"><!---para ver si hay que sobrescribir--->
			select count(1) as cantidad 
				from PCClasificacionE e
					inner join PCClasificacionD d
						inner join OficinasxClasificacion o
						on o.PCCDclaid=d.PCCDclaid
					on  e.PCCEclaid=d.PCCEclaid	
				where e.PCCEclaid=#form.PCCEclaid#
				and o.CGCmes=#form.smes# 
				and o.CGCperiodo=#form.speriodo#
				and o.PCCDclaid=#valor#
		</cfquery>
		
		<cfif rsSQL1.cantidad gt 0>
				<cfset variablesobre=variablesobre+1>
		</cfif>
</cfloop>

	<cfif variablecopia eq 0 ><!---no existen valores para copiar--->
			<cflocation url="CopiaPorcentajes1.cfm?bandera=1&periodo=#form.periodo#&params=#form.params#&mes=#form.mes#&smes=#form.smes#&speriodo=#form.speriodo#&PCCEclaid=#form.PCCEclaid#">
	</cfif>
	
	<cfif variablesobre gt 0>
			<cflocation url="CopiaPorcentajes1.cfm?bandera2=2&periodo=#form.periodo#&params=#form.params#&mes=#form.mes#&smes=#form.smes#&speriodo=#form.speriodo#&PCCEclaid=#form.PCCEclaid#">
	</cfif>
	
	<cfif variablecopia gt 0 and variablesobre eq 0>
		<cfloop list="#form.params#" delimiters="," index="aa">
			<cfset valor=#listgetat(aa, 1, ',')#>	
					<cfquery name="rsIns" datasource="#session.dsn#">
						insert into OficinasxClasificacion(
							PCCDclaid,
							PCDcatid,
							CGCperiodo,
							CGCmes,
							Ocodigo,
							CGCporcentaje,
							Ecodigo)
						select 
							o.PCCDclaid,
							o.PCDcatid,
							#form.speriodo#,
							#form.smes#,
							o.Ocodigo,
							o.CGCporcentaje,
							o.Ecodigo
						from PCClasificacionE e
							inner join PCClasificacionD d
								inner join OficinasxClasificacion o
								on o.PCCDclaid=d.PCCDclaid
							on  e.PCCEclaid=d.PCCEclaid	
						where e.PCCEclaid=#form.PCCEclaid#
						and o.CGCperiodo =#form.periodo# 
						and o.CGCmes=#form.mes#
						and o.PCCDclaid=#valor#
					</cfquery>
			</cfloop>
			<script language="JavaScript1.2">
			if (window.opener.funcfiltro) {window.opener.funcfiltro()}
			window.close();
		</script>		
	</cfif>
			<cfreturn>
</cfif>

<!---Sobreescribir valores en la copia del encabezado--->
<cfif isdefined ('form.sobret')>
<cfloop list="#form.params#" delimiters="," index="aa">
			<cfset valor=#listgetat(aa, 1, ',')#>
			
	<cfquery name="dlSQL" datasource="#session.dsn#">		
		delete from OficinasxClasificacion where Id in (select  o.Id	
						from PCClasificacionE e
				inner join PCClasificacionD d
					inner join OficinasxClasificacion o
					on o.PCCDclaid=d.PCCDclaid					
				on  e.PCCEclaid=d.PCCEclaid	
			where e.PCCEclaid=#form.PCCEclaid#
			and o.CGCmes=#form.smes# 
			and o.CGCperiodo=#form.speriodo#
			and o.PCCDclaid=#valor#)
	</cfquery>
		
		<cfquery name="rsIns" datasource="#session.dsn#">
				insert into OficinasxClasificacion(
					PCCDclaid,
					PCDcatid,
					CGCperiodo,
					CGCmes,
					Ocodigo,
					CGCporcentaje,
					Ecodigo)
				select 
					o.PCCDclaid,
					o.PCDcatid,
					#form.speriodo#,
					#form.smes#,
					o.Ocodigo,
					o.CGCporcentaje,
					o.Ecodigo
				from PCClasificacionE e
					inner join PCClasificacionD d
						inner join OficinasxClasificacion o
						on o.PCCDclaid=d.PCCDclaid
					on  e.PCCEclaid=d.PCCEclaid	
				where e.PCCEclaid=#form.PCCEclaid#
				and o.CGCperiodo =#form.periodo# 
				and o.CGCmes=#form.mes#
				and o.PCCDclaid=#valor#
			</cfquery>
		</cfloop>

			<script language="JavaScript1.2">
				if (window.opener.funcfiltro) {window.opener.funcfiltro()}
				window.close();
			</script>
	<cfreturn>
</cfif>

<cfif isdefined('form.chek')>
	<cflocation url="formPorcentajesOficinas.cfm?PCCEclaid=#form.PCCEclaid#&smes=#form.smes#&speriodo=#form.speriodo#&PCCDclaid=#form.PCCDclaid#&chk=1">
</cfif>
<cfif NOT isdefined('form.chek')>
	<cflocation url="formPorcentajesOficinas.cfm?PCCEclaid=#form.PCCEclaid#&smes=#form.smes#&speriodo=#form.speriodo#&PCCDclaid=#form.PCCDclaid#">
</cfif>

