<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isdefined("url.mcodigoopt") and url.mcodigoopt EQ "0" and isdefined("url.Mcodigo")> 
	<cfset varMcodigo = url.Mcodigo>
<cfelse>
	<cfset varMcodigo = -1>
</cfif>
<cfif isdefined("url.Ocodigo") and url.Ocodigo NEQ -1>
	<cfset varOcodigo = url.Ocodigo>
	<cfset NombreOficina = ''>
	<cfquery datasource="#session.dsn#" name="rsOficina">
		select o.Oficodigo #_Cat# ' - ' #_Cat# o.Odescripcion as Oficodigo
		from Oficinas o
		where o.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 and o.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varOcodigo#">	
	</cfquery>
	<cfif isdefined("rsOficina") and rsOficina.REcordCount NEQ 0>
		<cfset NombreOficina = rsOficina.Oficodigo>
	<cfelse>
		<cfset NombreOficina = 'Todas'>
	</cfif>
<cfelse>
	<cfset varOcodigo = -1>
	<cfset NombreOficina = 'Todas'>
</cfif>


<cfquery datasource="#session.dsn#" name="data" maxrows="5001">
	select
		c.Cformato, c.Ccuenta, c.Cdescripcion,
		hd.Eperiodo, hd.Emes, he.Efecha, hd.Ddocumento,
		hd.Ddescripcion, hd.Dreferencia, he.Ereferencia,
		hd.Dmovimiento,
		hd.Cconcepto, hd.Edocumento,
		coalesce (
			( select sum (s0.SLinicial)
				from SaldosContables s0
				where s0.Ccuenta = c.Ccuenta
				  and s0.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
				  and s0.Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
				  and s0.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			), 0) as SLinicial,
		coalesce (
			( select sum (s1.SLinicial + s1.DLdebitos - s1.CLcreditos)
				from SaldosContables s1
				where s1.Ccuenta = c.Ccuenta
				  and s1.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#">
				  and s1.Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">
				  and s1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			), 0) as SLfinal,
			rtrim(o.Oficodigo) #_Cat# ' - ' #_Cat# rtrim(o.Odescripcion) as Oficodigo,
		case when hd.Dmovimiento = 'D' then hd.Dlocal else 0 end as TotalDebitos,
		case when hd.Dmovimiento = 'C' then hd.Dlocal else 0 end as TotalCreditos
	from HDContables hd
		join HEContables he
			on he.IDcontable = hd.IDcontable
		join CContables c
			on c.Ccuenta = hd.Ccuenta
		join Oficinas o
		    on  o.Ecodigo = hd.Ecodigo
			and o.Ocodigo = hd.Ocodigo
			
	where hd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and hd.Eperiodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						and   <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#">
	  and (hd.Eperiodo >  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
	    or hd.Emes     >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">)
	  and (hd.Eperiodo <  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#">
	    or hd.Emes     <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">)

		<cfif Len(url.Cmayor_Ccuenta1) And Len(url.Cformato1)>
		  and c.Cformato >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Cmayor_Ccuenta1#-#url.Cformato1#">
		</cfif>
		<cfif Len(url.Cmayor_Ccuenta2) And Len(url.Cformato2)>
		  and c.Cformato <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Cmayor_Ccuenta2#-#url.Cformato2#">
		</cfif>
	
	<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
	  and hd.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varMcodigo#">	
	</cfif>
	<cfif isdefined("varOcodigo") and Len(varOcodigo) and varOcodigo NEQ -1>
	  and hd.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varOcodigo#">	
	</cfif>
	<cfif isdefined("url.ckOrdenXMonto") and url.ckOrdenXMonto EQ 1>
		order by c.Cformato, c.Ccuenta, rtrim(o.Oficodigo) #_Cat# ' - ' #_Cat# rtrim(o.Odescripcion), hd.Eperiodo, hd.Emes, hd.Dlocal desc, he.Efecha, hd.Ddescripcion 
	<cfelse>
		order by c.Cformato, c.Ccuenta, rtrim(o.Oficodigo) #_Cat# ' - ' #_Cat# rtrim(o.Odescripcion), hd.Eperiodo, hd.Emes, he.Efecha, hd.Ddescripcion 
	</cfif>
</cfquery>
<cfif isdefined("data") and data.recordcount gt 5000>
	<cf_errorCode	code = "50236" msg = "Se ha excedido la cantidad máxima de registros (5000).">
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','Póliza')>


<!--- Busca nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>


	
<!--- Invoca el Reporte --->		
	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
		<cfset formatos = "excel">
	</cfif>
	
  <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
		<cfif url.formato EQ "pdf">
		  <cfset typeRep = 2>
		</cfif>
		<cf_js_reports_service_tag queryReport = "#data#" 
				isLink = False 
				typeReport = #typeRep#
				fileName = "cg.consultas.HistoricoContabilidadxOficina"
				headers = "Empresa:#rsEmpresa.Edescripcion#"/>
	<cfelse>  
    <cfreport format="#formatos#" template= "HistoricoContabilidadxOficina.cfr" query="data">
      <cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
        <cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
      </cfif>
      
      
      <cfif isdefined("rsOcodigo") and rsOcodigo.recordcount gt 0>
        <cfreportparam name="Ocodigo" value="#rsOcodigo.Odescripcion#">
      </cfif>
      <cfif isdefined("PolizaE") and len(trim(PolizaE))>
        <cfreportparam name="PolizaE" value="#PolizaE#">
      </cfif>
      <cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
        <cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
      </cfif>
    </cfreport>
  </cfif>






        <!--- <table width="980"  border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td width="16">&nbsp;</td>
            <td colspan="2"><cfoutput>#DateFormat(Now(),'dd-mm-yyyy')# #TimeFormat(Now(), 'HH:mm:ss')#</cfoutput></td>
            <td width="91">&nbsp;</td>
            <td width="13">&nbsp;</td>
            <td colspan="4" align="center" style="font-size:18px"><cfoutput>#HTMLEditFormat(session.Enombre)#</cfoutput></td>
            <td width="90">&nbsp;</td>
            <td width="90">&nbsp;</td>
            <td width="46">&nbsp;</td>
            <td width="46">&nbsp;</td>
            <td width="12">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td width="43">&nbsp;</td>
            <td width="45">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="4" align="center" style="font-size:16px">Consulta Hist&oacute;rico de Contabilidad General</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
		            <tr>
            <td>&nbsp;</td>
            <td width="43">&nbsp;</td>
            <td width="45">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="4" align="center" style="font-size:12px">Oficina: &nbsp;<cfoutput>#NombreOficina#</cfoutput></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
		  
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td width="222">&nbsp;</td>
            <td width="10">&nbsp;</td>
            <td width="100">&nbsp;</td>
            <td width="100">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
		  <cfoutput query="data" group="Ccuenta">
          <tr>
            <td>&nbsp;</td>
            <td colspan="8"><strong>Cuenta: #data.Cformato# #data.Cdescripcion# </strong></td>
            <td align="right"><strong>Saldo Inicial </strong></td>
            <td align="right"><strong>#NumberFormat(data.SLinicial, '(,0.00)')#</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr class="listaCorte" style="background-color:navy;color:white;font-weight:bold">
            <td>&nbsp;</td>
            <td align="center">A&ntilde;o</td>
            <td align="center">Mes</td>
            <td align="center">Fecha</td>
            <td align="center">&nbsp;</td>
            <td>Descripci&oacute;n</td>
            <td>&nbsp;</td>
            <td>Referencia</td>
            <td>Documento</td>
            <td align="right">D&eacute;bitos</td>
            <td align="right">Cr&eacute;ditos</td>
            <td align="right">Lote</td>
            <td align="right">#PolizaE#</td>
            <td>&nbsp;</td>
          </tr>
		  <cfoutput>
          <tr class="<cfif (CurrentRow-1) Mod 4 gt 1>listaPar<cfelse>listaNon</cfif>">
            <td valign="top">&nbsp;</td>
            <td align="center" valign="top">#data.Eperiodo#</td>
            <td align="center" valign="top">#data.Emes#</td>
            <td align="center" valign="top">#DateFormat(data.Efecha,'yyyy-mm-dd')#</td>
            <td align="center" valign="top">&nbsp;</td>
            <td valign="top">#HTMLEditFormat(data.Ddescripcion)#</td>
            <td valign="top">&nbsp;</td>
            <td valign="top">#HTMLEditFormat(data.Dreferencia)#</td>
            <td valign="top">#HTMLEditFormat(data.Ddocumento)#</td>
            <td align="right" valign="top"><cfif data.Dmovimiento is 'D'>#NumberFormat(data.Dlocal, ',0.00')#</cfif>&nbsp;</td>
            <td align="right" valign="top"><cfif data.Dmovimiento is 'C'>#NumberFormat(data.Dlocal, ',0.00')#</cfif>&nbsp;</td>
            <td align="right" valign="top">#data.Cconcepto#</td>
            <td align="right" valign="top">#data.Edocumento#</td>
            <td valign="top">&nbsp;</td>
          </tr></cfoutput>
          <tr class="listaCorte">
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right"><strong>Saldo Final </strong></td>
            <td align="right"><strong>#NumberFormat(data.SLfinal, '(,0.00)')#</strong></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
		  </cfoutput>
			<cfif data.Recordcount NEQ 0>
			  <tr><td colspan="14" align="center">----------------------------------- Fin de la Consulta -----------------------------------</td></tr>
			<cfelse>
				<tr><td colspan="14" align="center">----------------------------------- No hay resultados -----------------------------------</td></tr>
		  	</cfif>
		  
        </table>
 --->

