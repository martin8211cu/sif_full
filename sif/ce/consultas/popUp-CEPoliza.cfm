
	<cfquery name="rsListaLineas" datasource="#session.DSN#">
        SELECT a.IDcontable,a.Dlinea, substring (a.Ddescripcion, 1, 50) AS Ddescripcion, b.CFformato,
                c.Mnombre, E.Edocumento, CASE WHEN a.Dmovimiento = 'D' THEN a.Dlocal
                                         ELSE 0 END AS Debitos,
                CASE WHEN a.Dmovimiento = 'C' THEN a.Dlocal
                ELSE 0 END AS Creditos,
                a.Dreferencia AS Dreferencia , a.Ddocumento AS Ddocumento,
                E.ECauxiliar
        FROM HEContables E
                INNER JOIN HDContables a on a.IDcontable = E.IDcontable
                INNER JOIN CFinanciera b on b.CFcuenta = a.CFcuenta
                    and a.Ecodigo = b.Ecodigo
                INNER JOIN Monedas c on c.Mcodigo = a.Mcodigo
                    and a.Ecodigo = c.Ecodigo
                INNER JOIN CtasMayor ct ON ct.Cmayor = b.Cmayor
                    and b.Ecodigo = ct.Ecodigo
                LEFT JOIN (select distinct IDcontable, Dlinea from CEInfoBancariaSAT) cei ON cei.IDcontable = a.IDcontable and cei.Dlinea = a.Dlinea
                LEFT JOIN (select Ccuenta,Ecodigo from CuentasBancos group by Ccuenta,Ecodigo) cb ON cb.Ccuenta = b.Ccuenta
                    and a.Ecodigo = cb.Ecodigo
                LEFT JOIN (select IdContable,linea, count(IdRep) cantidad,
							case when count(IdRep) >1 then -1
								else min(IdRep)
							end IdRep
						from CERepositorio
						group by IdContable,linea
				) cer ON cer.IdContable = a.IDcontable and cer.linea = a.Dlinea
        WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        	<cfif isdefined("url.idcontable") and len(trim(url.idcontable))>
        		AND a.IDcontable = (#url.idcontable#)
       		<cfif isdefined("url.periodo") and Len(Trim(url.periodo)) and trim(url.periodo) NEQ -1>
                AND a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(url.periodo)#">
            </cfif>
            <cfif isdefined("url.mes") and Len(Trim(url.mes)) and Trim(url.mes) NEQ -1>
                AND a.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(url.mes)#">
            </cfif>
        </cfif>
        ORDER BY a.IDcontable,E.Edocumento, a.Dlinea
    </cfquery>

	<cfquery name="Empresas" datasource="#Session.DSN#">
		select
			Ecodigo,
			Edescripcion
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfhtmlhead text="
	<style type='text/css'>
	td {  font-size: 11px; font-family: Verdana, Arial, Helvetica, sans-serif}
	a {
		text-decoration: none;
		color: ##000000;
	}
	.listaCorte { font-size: 11px; font-weight:bold; background-color:##CCCCCC; text-align:left;}
	.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
	.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}
	.listaLinea { background-color:##E8E8E8; font-weight:bold; vertical-align:middle; padding-left:5px;}
	.tituloSub { background-color:##FFFFFF; font-weight:bold; text-align: center; vertical-align: middle; font-size: smaller; border-color: black black ##CCCCCC; border-style: inset; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
	.tituloListas {

		font-weight: bolder;
		vertical-align: middle;
		padding: 5px;
		background-color: ##F5F5F5;
	}
	</style>">

<cfinvoke key="LB_Titulo" default="Consulta Poliza" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" xmlfile="popup-CEPoliza.xml"/>

	<table style="width:99%" align="center" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="8" align="right">
				&nbsp;
			</td>
		</tr>
		<cfoutput>
		<tr class="area">
			<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#Empresas.Edescripcion#</cfoutput></td>
		</tr>
		<tr class="area">
			<td align="center" colspan="8" nowrap><strong>#LB_Titulo#</strong></td>
		</tr>
		<tr>
			<td colspan="8" align="right"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>: <font color="##006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
		</tr>
	    <tr class="tituloListas">
			<td><strong>Poliza</strong></td>
			<td><strong>Linea</strong></td>
			<td width="20%"><strong>Descripcion</strong></td>
			<td width="20%"><strong>Cuenta Financiera</strong></td>
			<td><strong>Ref</strong></td>
			<td><strong>Documento</strong></td>
			<td><strong>Moneda</strong></td>
			<td><strong>Debito</strong></td>
			<td><strong>Credito</strong></td>
		</tr>
		<cfloop query="rsListaLineas">
		<tr class="<cfif Dlinea EQ url.linea>listaLinea<cfelse><cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif></cfif>">
			<td>#Edocumento#</td>
			<td>#Dlinea#</td>
			<td>#Ddescripcion#</td>
			<td>#CFformato#</td>
			<td>#Dreferencia#</td>
			<td>#Ddocumento#</td>
			<td>#Mnombre#</td>
			<td align="right">#LSCurrencyFormat(Debitos,"none")#</td>
			<td align="right">#LSCurrencyFormat(Creditos,"none")#</td>
		</tr>
		</cfloop>
		</cfoutput>
	</table>
