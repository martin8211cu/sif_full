<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 9-3-2006.
		Motivo: Se modifica para que conserve los valores en el regresar y se agrega botón de regresar. 
--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Regresar" Default="Regresar" 
returnvariable="BTN_Regresar" xmlfile = "/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="PolizasAplicadas" 
returnvariable="LB_Archivo" xmlfile = "formsaldosymov01.xml"/>
<cfif isdefined("Url.ccuenta") and not isdefined("form.ccuenta")>
	<cfset form.ccuenta = url.ccuenta>
</cfif>
<cfif isdefined("Url.cfcuenta") and not isdefined("form.cfcuenta")>
	<cfset form.cfcuenta = url.cfcuenta>
</cfif>
<cfif isdefined("Url.cformato") and not isdefined("form.cformato")>
	<cfset form.cformato = url.cformato>
</cfif>
<cfif isdefined("Url.cmayor") and not isdefined("form.cmayor")>
	<cfset form.cmayor = url.cmayor>
</cfif>

<cfif isdefined("Url.cmayor_id") and not isdefined("form.cmayor_id")>
	<cfset form.cmayor_id = url.cmayor_id>
</cfif>
<cfif isdefined("Url.cmayor_mask") and not isdefined("form.cmayor_mask")>
	<cfset form.cmayor_mask = url.cmayor_mask>
</cfif>

<cfif not isdefined("Url.exportar") and not isdefined("form.exportar")>
	<cfset form.exportar = false>
</cfif>

<cfif isdefined("Url.exportar") and not isdefined("form.exportar")>
	<cfset form.exportar = url.exportar>
</cfif>
<cfif isdefined("Url.mcodigo") and not isdefined("form.mcodigo")>
	<cfset form.mcodigo = url.mcodigo>
</cfif>
<cfif isdefined("Url.mcodigoopt") and not isdefined("form.mcodigoopt")>
	<cfset form.mcodigoopt = url.mcodigoopt>
</cfif>
<cfif isdefined("Url.periodos") and not isdefined("form.periodos")>
	<cfset form.periodos = url.periodos>
</cfif>


<cfquery name="rsCuentaContable" datasource="#Session.DSN#">
	select Cdescripcion, Cformato
	from CContables
	where Ecodigo = #session.Ecodigo#
	and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
</cfquery>
<cfset form.cdescripcion = rsCuentaContable.cdescripcion >

<script language="JavaScript">
	function Asignar(mes, oficina, periodo, MesCierre) {
		document.form2.Oficina.value=oficina;
		document.form2.Mes.value=mes;
		document.form2.PeriodoLista.value=periodo;
		document.form2.MesCierre.value=MesCierre;
		document.form2.submit();
	}
</script>
<cfif isdefined("url.Periodos") and not isdefined("form.periodos")>
	<cfparam name="Form.Periodos" default="#url.Periodos#">
	<cfparam name="Form.Ccuenta" default="#url.Ccuenta#">
	<cfparam name="Form.Cformato" default="#url.Cformato#">
</cfif>
<cfif isdefined("form.mcodigoopt") and form.mcodigoopt EQ "0">
	<cfset varMonedas = form.Mcodigo>
<cfelse>
	<!--- meter aqui la busqueda de moneda local de la empresa --->
	<cfquery name="rs_Monloc" datasource="#Session.DSN#">
		select Mcodigo 
		from Empresas 
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0>
		<cfset varMonedas = rs_Monloc.Mcodigo>
	</cfif>	
</cfif>

<cfquery name="Empresas" datasource="#Session.DSN#">
	select Ecodigo, Edescripcion 
	from Empresas 
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsUltimoMes" datasource="#Session.DSN#">
	select Pvalor 
	from Parametros
	where Ecodigo = #session.Ecodigo#  
	and Pcodigo = 45
	and Mcodigo = 'CG'
</cfquery>

<cfset LvarPrimerMes = 1>
<cfif isdefined('rsUltimoMes') and rsUltimoMes.recordcount GT 0>
	<cfset LvarPrimerMes = rsUltimoMes.Pvalor + 1>
	<cfif LvarPrimerMes EQ 13>
		<cfset LvarPrimerMes = 1>
	</cfif>
</cfif>


<!--- Falta:  
	1:  Identificar como se obtiene el Iid de las preferencias del usuario
--->

<!---<cfthrow  message="-#Session.Idioma#- #LvarPrimerMes#">--->
<cfquery name="rsMeses2" datasource="#Session.DSN#">
	select 
		1 as Orden, 
		<cf_dbfunction name='to_number' args="VSvalor"> as Mes, 
		VSdesc as Mesd , 
		<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.Periodos#"> as Periodo
	from VSidioma
	where VSgrupo = 1
    	<cfif #Rtrim(LTrim(Session.Idioma))# EQ "en">
        	and Iid=3
         <cfelse>   
	  		and Iid = 1
         </cfif>   
	  and <cf_dbfunction name='to_number' args="VSvalor"> >= #LvarPrimerMes#

	<cfif LvarPrimerMes NEQ 1>
		union
		select 
			2 as Orden, 
			<cf_dbfunction name='to_number' args="VSvalor"> as Mes, 
			VSdesc as Mesd, 
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.Periodos + 1 #"> as Periodo
		from VSidioma
		where VSgrupo = 1
		  <cfif #Rtrim(Ltrim(Session.Idioma))# EQ "en">
        	and Iid=3
         <cfelse>   
	  		and Iid = 1
         </cfif>  
		  and <cf_dbfunction name='to_number' args="VSvalor"> < #LvarPrimerMes#

		union
		select 
			3 as Orden, 
			#LvarPrimerMes# as Mes, 
			'<cf_translate key=LB_Cierre>Cierre</cf_translate>' as Mesd,  
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.Periodos+1#"> as Periodo
        from dual
		order by 1, 2

	<cfelse>
		union
		select 
			3 as Orden, 
			#LvarPrimerMes# as Mes, 
			'<cf_translate key=LB_Cierre>Cierre</cf_translate>' as Mesd, 
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.Periodos+1#"> as Periodo
         from dual
	order by 1, 2
	</cfif>
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
		SELECT distinct a.Ocodigo, b.Oficodigo 
		FROM SaldosContables a
			inner join Oficinas b
				on a.Ecodigo = b.Ecodigo
		       and a.Ocodigo = b.Ocodigo
		where a.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
		  and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Periodos#">
		  <cfif isdefined('form.Mcodigo') and len(form.Mcodigo) and isdefined("form.McodigoOpt") and form.McodigoOpt GTE 0>
			  and a.Mcodigo = #varMonedas#
		  </cfif>
		  
	<cfif LvarPrimerMes NEQ 1>
		union
		SELECT distinct a.Ocodigo, b.Oficodigo 
		FROM SaldosContables a
			inner join Oficinas b
				on a.Ecodigo = b.Ecodigo
		       and a.Ocodigo = b.Ocodigo	
		where a.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
		  and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Periodos+1#">
		  <cfif isdefined('form.Mcodigo') and len(form.Mcodigo) and isdefined("form.McodigoOpt") and form.McodigoOpt GTE 0>
			  and a.Mcodigo = #varMonedas#
		  </cfif>
	</cfif>
	 order by Oficodigo
</cfquery>

<cfif rsOficinas.recordcount LT 1>
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select o.Ocodigo, o.Oficodigo
		from Oficinas o
		where o.Ecodigo = #Session.Ecodigo#
		order by o.Oficodigo
	</cfquery>
</cfif>

<cfset LvarOficinas = arraynew(1)>
<cfset o = 0>
<cfloop query="rsOficinas">
	<cfset o = o + 1>
	<cfset LvarOficinas[o] = rsOficinas.Ocodigo>
</cfloop>

<cfif isdefined("url.toexcel")>
	<cfcontent type="application/vnd.ms-excel">
	<cfheader 	name="Content-Disposition" 
			value="attachment;filename=#LB_Archivo#_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
</cfif>
<form name="form2" action="saldosymov02.cfm" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
			<cfoutput>
				<td align="right" width="100%" colspan="3"> 
				<cfparam name="form.CFcuenta" default=" ">
				<cfparam name="form.cmayor_id" default=" ">
				<cfparam name="form.cmayor_mask" default=" ">
				
				<cfset params = "ccuenta=#Form.ccuenta#&cdescripcion=#rsCuentaContable.cdescripcion#&cfcuenta=#Form.cfcuenta#&cformato=#Form.cformato#&cmayor=#Form.cmayor#&cmayor_id=#Form.cmayor_id#&cmayor_mask=#Form.cmayor_mask#&mcodigo=#Form.mcodigo#&mcodigoopt=#Form.mcodigoopt#&periodos=#Form.periodos#">
					<cfif isdefined("url.toexcel")>
						&nbsp;
					<cfelse>	
						<a href="javascript:SALVAEXCEL();">  
						<cf_translate key=LB_Exportar>Exportar</cf_translate></a>
					</cfif>
				</td>	
			</cfoutput>
		</tr>
	</table>
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td colspan="4" class="tituloAlterno"><div align="center">#Empresas.Edescripcion#</div></td>
	</tr>
	<tr> 
		<td colspan="4" align="center" class="tituloAlterno"><font size="2"><cf_translate key=LB_Titulo>Saldos y Movimientos</cf_translate></font></td>
	</tr>

	<tr> 
		<td align="center" colspan="4">&nbsp;</td>
	</tr>
	<tr> 
		<td width="7%" align="right" class="tituloAlterno"><cf_translate key=LB_Cuenta>Cuenta</cf_translate>:</td>
		<td class="tituloAlterno">#rsCuentaContable.Cdescripcion# : #rsCuentaContable.Cformato# <cfif rsCuenta.Cmovimiento eq 'N'>(<cf_translate key=LB_Nivel>Este nivel no acepta mov.</cf_translate>)</cfif></td>
		<td width="8%" class="tituloAlterno"><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate>:</td>
		<td width="16%" class="tituloAlterno">#Form.Periodos#<cfif LvarPrimerMes NEQ 1>-#Form.Periodos+1#</cfif></td>
	</tr>
	</table>
	<table width="100%" border="0" cellpadding="4">
	<tr> 
		<td bgcolor="silver">&nbsp;</td>
		<td align="center"  bgcolor="silver" colspan="#rsOficinas.RecordCount#" nowrap>
			<font size="2"><strong><cf_translate key=LB_Oficina>Oficina </cf_translate>(s)</strong></font>
		</td>
		<td bgcolor="silver">&nbsp;</td>
	</tr>
	<tr>
	<td nowrap><strong><cf_translate key=LB_Mes>Mes</cf_translate></strong></td>
	</cfoutput>

	<cfoutput query="rsOficinas">
		<td nowrap align="right"><strong>#rsOficinas.Oficodigo#</strong></td>
	</cfoutput>
		<td nowrap align="right"><strong>Total</strong></td>
	</tr>
	<cfset contador = 0>
	<cfoutput query="rsMeses2">
		<cfset contador = contador + 1>
		<tr <cfif contador mod 2> class="listaPar"<cfelse>class="listaNon"</cfif>>
		<td nowrap ><!--- #rsMeses2.Periodo#- --->#rsMeses2.Mesd#:</td>
		<cfset LvarTotalMes = 0>	
		<cfloop index="i" from="1" to="#o#">
			<cfquery name="rsSaldos" datasource="#Session.DSN#">
				SELECT sum(SLinicial <cfif rsMeses2.Orden NEQ 3>+DLdebitos-CLcreditos</cfif>) as Total
				FROM SaldosContables a
				where a.Ccuenta =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
				  and a.Speriodo = #rsMeses2.Periodo#
				  and a.Smes     = #rsMeses2.Mes#
				  and a.Ecodigo  = #session.Ecodigo#
				  and a.Ocodigo  = #LvarOficinas[i]#
				  <cfif isdefined('form.McodigoOpt') and form.McodigoOpt GTE 0>
					  and a.Mcodigo = #varMonedas#
				  </cfif>
			</cfquery>
			<cfif isdefined('rsSaldos') and len(rsSaldos.Total) GT 0>
				<td nowrap align="right">
					<a href="javascript:Asignar(#rsMeses2.Mes#,#LvarOficinas[i]#,#rsMeses2.Periodo#, '#rsMeses2.Orden EQ 3#');">
					<font <cfif rsSaldos.Total LT 0>color="red"</cfif>>#lsnumberformat(rsSaldos.Total, ",9.00")#</font>
					</a>
				</td>
				<cfset LvarTotalMes = LvarTotalMes + rsSaldos.Total>
			<cfelse>
				<td nowrap align="right">0.00</td>
			</cfif>
		</cfloop>
		<td nowrap align="right"><font <cfif LvarTotalMes LT 0>color="red"</cfif>>#lsnumberformat(LvarTotalMes, ",9.00")#</font></td>
		</tr>	
	</cfoutput>
	<cfoutput>
	</table>
	<cfif not isdefined("url.toexcel")>
		<div align="center"><input name="btnRegresar" value="#BTN_Regresar#" type="button" onclick="funcRegresarA()"></div>
		<input name="Ccuenta" value="#Form.Ccuenta#" type="hidden">
		<input name="Periodo" value="#Form.Periodos#" type="hidden">
		<input name="PeriodoLista" value="" type="hidden">
		<input name="Mes" value="" type="hidden">
		<input name="Oficina" value="" type="hidden">
		<input name="Mcodigo" value="<cfif isdefined("form.Mcodigo")>#form.Mcodigo#</cfif>" type="hidden">
		<input name="McodigoOpt" value="<cfif isdefined("form.McodigoOpt")>#form.McodigoOpt#</cfif>" type="hidden">
		<input name="MesCierre" value="" type="hidden">
	</cfif>
	</cfoutput>
</form>

<iframe src="" id="prueba" style="visibility:hidden" width="0" height="0"></iframe>
<script language="javascript" type="text/javascript">
	function funcRegresarA() {
		document.form2.action = 'saldosymov.cfm';
		document.form2.submit();
	}
	
	function SALVAEXCEL() {
		<cfset params = 'toexcel=1' >
		<cfif isdefined("form.ccuenta")>
			<cfset params = params & "&ccuenta=#form.ccuenta#" >
		</cfif>
		<cfif isdefined("form.cfcuenta")>
			<cfset params = params & "&cfuenta=#form.cfcuenta#" >
		</cfif>
		<cfif isdefined("form.cformato")>
			<cfset params = params & "&cformato=#form.cformato#" >	
		</cfif>
		<cfif isdefined("form.cmayor")>
			<cfset params = params & "&cmayor=#form.cmayor#" >	
		</cfif>
		
		<cfif isdefined("form.cmayor_id")>
			<cfset params = params & "&cmayor_id=#form.cmayor_id#" >	
		</cfif>
		<cfif isdefined("form.cmayor_mask")>
			<cfset params = params & "&cmayor_mask=#form.cmayor_mask#" >		
		</cfif>
		<cfif isdefined("form.mcodigo")>
			<cfset params = params & "&mcodigo=#form.mcodigo#" >			
		</cfif>
		<cfif isdefined("form.mcodigoopt")>
			<cfset params = params & "&mcodigoopt=#form.mcodigoopt#" >				
		</cfif>
		<cfif isdefined("form.periodos")>
			<cfset params = params & "&periodos=#form.periodos#" >				
		</cfif>

		var ira = '?<cfoutput>#jsstringformat(params)#</cfoutput>';
		document.getElementById("prueba").src="saldosymov01.cfm" + ira;
		
	}	
</script>