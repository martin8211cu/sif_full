
<cfif isdefined ('form.imp')>
<cflocation url="form_Importar_ValoresxConductor.cfm?CGCid=#form.CGCid#&speriodo=#form.speriodo#&smes=#form.smes#">
</cfif>
<cfif isdefined ('form.imp')>
	<cflocation url="form_Importar_ValoresxConductor.cfm?CGCid=#form.CGCid#&speriodo=#form.speriodo#&smes=#form.smes#">
</cfif>

<!---Copia de valores Totales--->
<cfif isdefined ('form.Copiar')>
	<cfset variablecopia=0><!---existen valores para copiar-SQL--->
	<cfset variablesobre=0><!---existen valores para sobrescribir-SQL1--->
	
	<cfloop list="#form.params#" delimiters="," index="aa">
		<cfset valor=#listgetat(aa, 1, ',')#>		
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select * from CGParamConductores
				where CGCid=#valor#
				and CGCperiodo=#form.periodo#
				and CGCmes=#form.mes#
			</cfquery>
			
			<cfif rsSQL.recordcount gt 0>
				<cfset variablecopia=variablecopia+1>
			</cfif>
			
			<cfquery name="rsSQL1" datasource="#session.dsn#">
				select * from CGParamConductores
				where CGCid=#valor#
				and CGCperiodo=#form.speriodo#
				and CGCmes=#form.smes#
			</cfquery>
			
			<cfif rsSQL1.recordcount gt 0>
				<cfset variablesobre=variablesobre+1>
			</cfif>
	</cfloop>
	
	<cfif variablecopia eq 0 ><!---no existen valores para copiar--->
		<cflocation url="CGCCopiarValores.cfm?bandera1=1&params=#form.params#&smes=#form.smes#&speriodo=#form.speriodo#&mes=#form.mes#&periodo=#form.periodo#">
	</cfif>
	
	<cfif variablesobre gt 0>
		<cflocation url="CGCCopiarValores.cfm?bandera=1&params=#form.params#&smes=#form.smes#&speriodo=#form.speriodo#&mes=#form.mes#&periodo=#form.periodo#">
	</cfif>
	
	<cfif variablecopia gt 0 and variablesobre eq 0>
		<cfloop list="#form.params#" delimiters="," index="aa">
			<cfset valor=#listgetat(aa, 1, ',')#>		
					<cfquery name="inSQL" datasource="#session.dsn#">
						insert into CGParamConductores(
								Ecodigo
								,CGCperiodo
								,CGCmes
								,CGCid
								,PCCDclaid
								,PCDcatid
								,CGCvalor 
								,BMUsucodigo
							)
						select  #session.Ecodigo#
								,#form.speriodo#
								,#form.smes#
								,CGCid
								,PCCDclaid
								,PCDcatid
								,CGCvalor 
								,#session.usucodigo# 
						from CGParamConductores
							where CGCid=#valor#
							and CGCperiodo=#form.periodo#
							and CGCmes=#form.mes#					
					</cfquery>	
			</cfloop>
			<script language="JavaScript1.1">
				if (window.opener.funcfiltro) {window.opener.funcfiltro()}
				window.close();
			</script>
	</cfif>
	<cfreturn>
</cfif>

<!---Sobrescribir valores--->
<cfif isdefined('form.sobre')>
<cfloop list="#form.params#" delimiters="," index="aa">
			<cfset valor=#listgetat(aa, 1, ',')#>		
			
	<cfquery name="dlSQL" datasource="#session.dsn#">
		delete from 
			CGParamConductores 
		where 
			CGCperiodo=#form.speriodo#
			and CGCmes=#form.smes#
			and  CGCid=#valor#
	</cfquery>
	
					<cfquery name="inSQL" datasource="#session.dsn#">
						insert into CGParamConductores(
								Ecodigo
								,CGCperiodo
								,CGCmes
								,CGCid
								,PCCDclaid
								,PCDcatid
								,CGCvalor 
								,BMUsucodigo
							)
						select  #session.Ecodigo#
								,#form.speriodo#
								,#form.smes#
								,CGCid
								,PCCDclaid
								,PCDcatid
								,CGCvalor 
								,#session.usucodigo# 
						from CGParamConductores
							where CGCid=#valor#
							and CGCperiodo=#form.periodo#
							and CGCmes=#form.mes#					
					</cfquery>	
		</cfloop>
		<script language="JavaScript1.1">
				if (window.opener.funcfiltro) {window.opener.funcfiltro()}
				window.close();
			</script>
		<cfreturn>
</cfif>


<!---Copia de valores Detalles--->
<cfif isdefined ('form.copiarD')>
			<cfquery name="rsSQL" datasource="#session.dsn#"><!---existen valores para copiar--->
				select * from CGParamConductores
				where CGCid=#form.CGCid#
				and CGCperiodo=#form.periodo#
				and CGCmes=#form.mes#
			</cfquery>
		
			<cfquery name="rsSQL1" datasource="#session.dsn#"><!---si existe necesidad de sobrescribir--->
				select * from CGParamConductores
				where CGCid=#form.CGCid#
				and CGCperiodo=#form.speriodo#
				and CGCmes=#form.smes#
			</cfquery>
			

	<cfif rsSQL.recordcount eq 0 ><!---no existen valores para copiar--->
		<cflocation url="CGCCopiarValoresD.cfm?bandera1=1&CGCid=#form.CGCid#&smes=#form.smes#&speriodo=#form.speriodo#&mes=#form.mes#&periodo=#form.periodo#">
	</cfif>
	
	<cfif rsSQL1.recordcount gt 0>
		<cflocation url="CGCCopiarValoresD.cfm?bandera=1&CGCid=#form.CGCid#&smes=#form.smes#&speriodo=#form.speriodo#&mes=#form.mes#&periodo=#form.periodo#">
	<cfelse>
		
					<cfquery name="inSQL" datasource="#session.dsn#">
						insert into CGParamConductores(
								Ecodigo
								,CGCperiodo
								,CGCmes
								,CGCid
								,PCCDclaid
								,PCDcatid
								,CGCvalor 
								,BMUsucodigo
							)
						select  #session.Ecodigo#
								,#form.speriodo#
								,#form.smes#
								,CGCid
								,PCCDclaid
								,PCDcatid
								,CGCvalor 
								,#session.usucodigo# 
						from CGParamConductores
							where CGCid=#form.CGCid#
							and CGCperiodo=#form.periodo#
							and CGCmes=#form.mes#					
					</cfquery>	
		
			<script language="JavaScript1.1">
				if (window.opener.funcfiltro) {window.opener.funcfiltro()}
				window.close();
			</script>
	</cfif>
	<cfreturn>
</cfif>

<!---Sobrescribir valores--->
<cfif isdefined('form.sobreD')>
	<cfquery name="dlSQL" datasource="#session.dsn#">
		delete from 
			CGParamConductores 
		where 
			CGCperiodo=#form.speriodo#
			and CGCmes=#form.smes#
			and CGCid=#form.CGCid#
	</cfquery>
			
					<cfquery name="inSQL" datasource="#session.dsn#">
						insert into CGParamConductores(
								Ecodigo
								,CGCperiodo
								,CGCmes
								,CGCid
								,PCCDclaid
								,PCDcatid
								,CGCvalor 
								,BMUsucodigo
							)
						select  #session.Ecodigo#
								,#form.speriodo#
								,#form.smes#
								,CGCid
								,PCCDclaid
								,PCDcatid
								,CGCvalor 
								,#session.usucodigo# 
						from CGParamConductores
							where CGCid=#form.CGCid#
							and CGCperiodo=#form.periodo#
							and CGCmes=#form.mes#					
					</cfquery>	
		
			<script language="JavaScript1.1">
				if (window.opener.funcfiltro) {window.opener.funcfiltro()}
				window.close();
			</script>
<cfreturn>
</cfif>

<!---Botones de regresar--->
<cfif isdefined('form.reg1')>
	<cflocation url="Valor_Conductor_listaC.cfm?smes=#form.smes#&speriodo=#form.speriodo#">
</cfif>
<cfif isdefined('form.reg')>
	<cflocation url="Valor_Conductor.cfm">
</cfif>
<cfif isdefined('form.chek')>
	<cflocation url="Valor_Conductor_form.cfm?CGCid=#form.CGCid#&smes=#form.smes#&speriodo=#form.speriodo#&chk=1">
</cfif>
<cfif NOT isdefined('form.chek')>
	<cflocation url="Valor_Conductor_form.cfm?CGCid=#form.CGCid#&smes=#form.smes#&speriodo=#form.speriodo#">
</cfif>

