<cfparam name="LvarPagina" default="/cfmx/sif/fa/operacion/listaTransaccionesFA.cfm">
<cfparam name="LvarSQLPagina" default="SQLAbrirCaja.cfm">

<cftry>

	<cfif isdefined("Form.btnAceptar")>
  
	  <cfif not isDefined('form.CJC') or (isDefined('form.CJC') and  form.CJC neq 2)>
            <cfquery name="CajasActivas" datasource="#Session.DSN#">
              select fa.FCid, isnull(f.MontoFondeo,0) MontoFondeo  from FCajasActivas fa 
              inner join FCajas f on fa.FCid = f.FCid 
              where fa.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
              and 	EUcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EUcodigo#">
            </cfquery>
            
            <cfif isdefined('CajasActivas') and CajasActivas.recordcount eq 0 >
                <cf_dbfunction name="now" returnvariable="LvarHoy">
                <cfquery name="CajasActivas2" datasource="#Session.DSN#">
                    insert FCajasActivas (FCid, EUcodigo, FCAfecha)
                    values (
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EUcodigo#">,
                        #LvarHoy#
                    )
                </cfquery>
                 <cfquery name="CajasActivas2" datasource="#Session.DSN#">
                  update FCajas set FCestado = 1,
                          MontoFondeo = #numberformat(form.aumentoFondo,"9.99")#
                  where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                 </cfquery>
            </cfif>
            <cfset Session.Caja = Form.FCid>
	  </cfif>
  </cfif>
<cfcatch type="any">
	<cfinclude template="../../errorPages/BDerror.cfm">
</cfcatch>
</cftry>
<cfif  IsDefined('form.CC') and form.CC eq 1 >
  <form action="../operacion/RecibePagosLista.cfm" method="post" name="sql">
<cfelseif  IsDefined('form.lq') and form.lq eq 1 >
  <form  action="../operacion/LiquidacionCajero.cfm" method="post" name="sql">
<cfelseif isDefined('form.nc') and form.nc eq 1>
  <form  action="../../cc/operacion/AplicacionNotaCredito.cfm" method="post" name="sql">
<cfelseif isDefined('form.CJC') and form.CJC eq 1>
  <form  action="../operacion/CierreCaja.cfm" method="post" name="sql">
<cfelseif isDefined('form.CJC') and form.CJC eq 2>
  <form  action="../operacion/CierreCaja-supervisor.cfm" method="post" name="sql">
     <input type="hidden" name="VistaCaja" value="true">
     <input type="hidden" name="IdCaja" value="<cfoutput>#Form.FCid#</cfoutput>">
<cfelseif isDefined('form.IR') and form.IR eq 1>
  <form  action="../operacion/InclusionRemesas.cfm" method="post" name="sql">
<cfelse>
  <form action="<cfoutput>#LvarPagina#</cfoutput>" method="post" name="sql">
</cfif>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

