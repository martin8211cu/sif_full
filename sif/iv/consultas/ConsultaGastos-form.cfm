<!--- <cffunction name="get_articulo" access="public" returntype="query">

	<cfargument name="acodigo" type="numeric" required="true" default="<!--- Código de la línea de Título --->">

	<cfquery name="rsget_articulo" datasource="#session.DSN#" >

		select rtrim(Adescripcion) as Adescripcion from Articulos

		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

		and Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#acodigo#">

	</cfquery>

	<cfreturn #rsget_articulo#>

</cffunction> 



<cffunction name="get_acodigo" access="public" returntype="query">

	<cfargument name="aid" type="numeric" required="true" default="<!--- Código de la línea de Título --->">

	<cfquery name="rsget_acodigo" datasource="#session.DSN#" >

		select Acodigo from Articulos

		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

		and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#aid#">

	</cfquery>

	<cfreturn #rsget_acodigo#>

</cffunction>

--->

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cf_sifHTML2Word Titulo="Artículos">
<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>

<cfif isdefined("url.ckPend")>
	<cfset form.ckPend = url.ckPend>
</cfif>
<cfif isdefined("url.ETid") and not isdefined("form.ETid")>
	<cfset form.ETid = url.ETid>
</cfif>
<!--- ======================================================================================================================= --->
<!--- ======================================================================================================================= --->
<form name="form1" method="post">
  <table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
   <tr> 
      <td colspan="10" class="tituloAlterno" align="center"><font size="2"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></font></td>
    </tr>
    <tr> 
     <td colspan="10">&nbsp;</td>
   </tr>
    <tr> 
      <td colspan="10" align="center"><font size="3"><b>Consulta de Gastos de
      Producci&oacute;n.</b></font></td>
    </tr>
	<cfoutput> 
		<tr>
			<td colspan="10" align="center"><font size="2"><b>Fecha:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</font></td>
		</tr>

		<cfif isdefined('Url.ETid') and ltrim(rtrim(Url.ETid)) and not isdefined("form.ETid")>
			<cfset form.ETid = Url.ETid>
		</cfif>
	</cfoutput>
	  <cfset filtro = "">
	
		<cfquery datasource="#Session.DSN#" name="rsRango">
			  select distinct c.Cid ,c.Ecodigo, c.Ccodigo, c.Cdescripcion, c.Ctipo, 
				gp.GPid , gp.ETid  , gp.Cid, coalesce(gp.GPmonto,0) as GPmonto,
				gp.GPtipocambio, gp.Mcodigo, m.Mnombre
			from Conceptos c, CPGastosProduccion gp, Monedas m
			where c.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
			  and gp.ETid = <cfqueryparam value="#form.ETid#" cfsqltype="cf_sql_numeric">
			  and Ctipo = 'G'
			  and c.Cid = gp.Cid
			  and gp.Mcodigo = m.Mcodigo
			  and gp.GPmonto is not null
			  and gp.GPmonto <> 0.00
		</cfquery>
		<cfoutput> 
			<cfset vMontoTotal =0>
			<cfloop query="rsRango">
				<cfset NombreMoneda= "">
				<cfset Moneda= rsRango.Mcodigo>
				<cfset vMontoTotal  = vMontoTotal + rsRango.GPmonto >
				<cfif rsRango.Currentrow EQ 1>
					<tr> 
						<td colspan="15" >&nbsp; <input name="ETid" type="hidden" value="<cfif isdefined("form.ETid")>#form.ETid#</cfif>">
						</td>
					</tr>
					<tr align="center" bgcolor="##33CCFF">
					  <td nowrap bgcolor="##00CCFF" ><div align="center" ><font size="2"><strong>C&oacute;digo</strong></font></div>
				      </td>
					  <td nowrap ><div align="center"><font size="2"><strong>Descripci&oacute;n del
			          Gasto</strong></font></div></td>
					  <td ><div align="center"><font size="2"><strong>Tipo de Cambio</strong></font></div></td>
					  <td nowrap ><div align="center"><font size="2"><strong>Moneda</strong></font></div></td>
					  <td ><div align="center"><font size="2"><strong>Monto</strong></font></div></td>
					</tr>
				</cfif>
				<tr align="right">
					<td align="left" bgcolor="##FFFFFF" ><div align="left">#rsRango.Ccodigo#</div></td>
					<td align="left" bgcolor="##CCCCCC" ><div align="left">#rsRango.Cdescripcion# </div></td>
				  	<td bgcolor="##FFFFFF" ><div align="center">#LSCurrencyFormat(rsRango.GPtipocambio,"none")#</div>
				  	</td>
				  	<td align="center" bgcolor="##CCCCCC"><div align="center">#rsRango.Mnombre#</div></td>
					<td align="center" bgcolor="##FFFFFF"><div align="right">#LSCurrencyFormat(rsRango.GPmonto,"none")#</div></td>
				</tr>
			</cfloop>
			<tr>
			  <td colspan="15" >&nbsp;</td>
		  </tr>
			<tr> 
				<td class="topLine"><strong>Total</strong></td>
				<!---<td>&nbsp;</td>
				<td>&nbsp;</td>--->
				<td class="topLine" colspan="4" align="right" nowrap><strong>#LSNumberFormat(vMontoTotal,',9.00')#</strong></td>
			</tr>
			<cfif rsRango.Recordcount NEQ 0>
			 <tr>
				<td colspan="10" align="center">------------------ Fin del Reporte ------------------</td>
			  </tr>					
			<cfelse> 
				 <tr>
					<td colspan="10" align="center">------------------ No existen Registros ------------------</td>
			  </tr>					
			</cfif>	
		</cfoutput> 			
  </table>
</form>
</cf_sifHTML2Word>