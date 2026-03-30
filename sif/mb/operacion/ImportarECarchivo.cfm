<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 26 de mayo del 2005
	Motivo:	forma para el proceso de importación de los estados de cuenta.  
			Se utiliza el tag de impracion q ya a sido definido. 
----------->
  <cfset EICODIGO = "">
<cfif isdefined('LvarTCEstadosCuenta') and LvarTCEstadosCuenta eq '1'>
  <cfset _Pagina      = "EstadosCuentaTCE.cfm">  
  <cfset _PaginaRet = "listaEstadosCuentaTCE.cfm">   
  <cfset LvarCBesTCE  = 1>
      <cfset LvarTitulo ="Tarjetas de Crédito Empresarial">
      <cfset EICODIGO = "TCEESTADOCTA">
<cfelse>
  <cfset _Pagina      = "EstadosCuenta.cfm">    
  <cfset _PaginaRet = "listaEstadosCuenta.cfm">   
  <cfset LvarCBesTCE  = 0>
  <cfset LvarTitulo ="Bancos">
</cfif>

<cf_templateheader title="#LvarTitulo#">
<cfif isdefined('Session.ImportarECuenta.ECid') and len(trim(Session.ImportarECuenta.ECid)) and LvarCBesTCE eq 0>

    <cfquery name="rsImportador" datasource="#session.DSN#">
        select EIid
        from ECuentaBancaria a left outer join CuentasBancos b
          on a.Bid = b.Bid and 
             a.CBid = b.CBid
        where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
        	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and b.CBesTCE = <cfqueryparam value="#LvarCBesTCE#" cfsqltype="cf_sql_numeric">
    </cfquery>
    
    <cfif isdefined('rsImportador') and LEN(rsImportador.EIid) EQ 0>
        <cfquery name="rsImportador" datasource="#session.DSN#">
            select EIid	
            from ECuentaBancaria a left outer join Bancos b
              on a.Bid = b.Bid
            where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
              and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        </cfquery>		
	</cfif> 
    <cfif isdefined('rsImportador') and LEN(rsImportador.EIid) GT 0>
        <cfquery name="rsArchivo" datasource="sifcontrol">
            select EIid, EIcodigo
            from EImportador
            where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsImportador.EIid#">
        </cfquery>        
	</cfif>	 
<cfelseif LvarCBesTCE eq 1>
        <cfquery name="rsArchivo" datasource="sifcontrol">
            select EIid,EIcodigo
            from EImportador
            where EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EICODIGO#">  
        </cfquery>        
</cfif>



		<cf_web_portlet_start border="true" titulo="Importación de Estados de Cuenta" skin="#Session.Preferences.Skin#">
			<cfset regresar = "ListaEstadosCuenta.cfm">
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  	<tr><td align="center" colspan="2">&nbsp;</td></tr>
			  	<tr>
					<cfif isdefined('rsArchivo') and rsArchivo.RecordCount GT 0>
                    <cfset EICODIGO = #rsArchivo.EIcodigo#>                     
					<td width="54%">
                    <!---<cf_sifInfoImportar EIid="#rsArchivo.EIid#" EIcodigo="#EICODIGO#" mode="in">--->
                    <cf_sifFormatoArchivoImpr EIcodigo="#EICODIGO#" tabindex="1">
                    </td>
					<td width="15%" align="center" valign="top" style="padding-left: 15px ">
						<cf_sifimportar EIid="#rsArchivo.EIid#" EIcodigo="#EICODIGO#" mode="in">
					</td>
					<td width="23%" valign="top">
						<cfif isdefined('LvarTCEstadosCuenta') and LvarTCEstadosCuenta eq '1'>
                            <cfoutput>							
                                     <input name="Regresar" type="button" value="Regresar" 
                                     onClick="javascript: funcRegresarTCE();">                             
                                    
                            </cfoutput>
                            
                        <cfelse>
							<cfoutput>							
                                    <cfif isdefined('Session.ImportarECuenta.ECid') and len(trim(#Session.ImportarECuenta.ECid#))>
                                      <input name="Regresar" type="button" value="Regresar" 
                                       onClick="javascript: funcRegresar('#Session.ImportarECuenta.ECid#');">                             
                                    </cfif>   
                            </cfoutput>
                        </cfif>    
					</td>
					<cfelse>
						<td width="8%" align="center"><strong>No se ha definido un formato de Importador de Estados de Cuenta.</strong></td>
					</cfif>
			  	</tr>
				<tr><td></td></tr>
			</table>
		<cf_web_portlet_end>

  
	<cf_templatefooter>

<script  language="JavaScript1.2">
	function funcRegresar(ECid){
		location.href = "<cfoutput>#_Pagina#</cfoutput>?ECid=" + ECid;
	}
	function funcRegresarTCE(){
		location.href = "<cfoutput>#_PaginaRet#</cfoutput>#";
	}
</script>