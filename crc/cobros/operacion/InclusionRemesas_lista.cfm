<cfset navegacion=''>
<cf_dbfunction name="OP_concat"	args=""  returnvariable="_Cat" >
<cfparam name="form.chkTodas" default="0">
<cfif isdefined ('CBid')>
	<cfset form.CBid=ListFirst(#CBid#,',')>
</cfif>
<cfif isdefined ('url.num') and not isdefined('form.num')>
	<cfset form.num=#url.num#>
</cfif>
<cfif not isDefined("Session.Caja")>
                   <cflocation addtoken="no" url="../catalogos/AbrirCaja.cfm?IR=1">
        </cfif>

<table width="100%" border="0">
	<form name="form1" method="post">
    <cfif isdefined('url.NumLote')>
     <input type="hidden" name="NumLote" value="#url.NumLote#" />
     </cfif>
         <cfif isdefined('form.NumLote')>
     <input type="hidden" name="NumLote" value="#form.NumLote#" />
     </cfif>
            <cfquery name="rsSQL" datasource="#session.dsn#">
				select ERid, NumDeposito, e.FCid,MntEfectivo, MntCheque, REstado,FCdesc,Fremesa, CBdescripcion,RNumLote
					from ERemesas e
                    inner join FCajas a
                    on e.FCid = a.FCid
                    and a.Ecodigo = #session.Ecodigo#
                    inner join CuentasBancos cb
                    on cb.CBid = e.CBid                  
                    and e.FCid = #session.Caja#
                    where REstado = 'E'
                    <cfif isdefined('url.NumLote')>
                    and RNumLote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.NumLote#">
                    <cfelse>
                    and RNumLote is NULL
                    </cfif>
                   <!--- <cfif isdefined('form.NumLote')>
                    and RNumLote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumLote#">
                    <cfelse>
                    and RNumLote is NULL
                    </cfif>--->
			</cfquery>
		</form>	
		<tr>
			<td colspan="7">
            <cfif isdefined('url.NumLote')>
            
            <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#rsSQL#"
					columnas="ERid,NumDeposito,CBdescripcion,FCid,MntEfectivo, MntCheque, Fremesa"
					desplegar="NumDeposito,CBdescripcion,MntEfectivo+MntCheque,Fremesa"
					etiquetas="Numero Depósito,Cuenta Bancaria,Monto Total, Fecha"
					formatos="S,S,M,D"
					align="left,left,left,left"
					ira="InclusionRemesas.cfm?NumLote=#url.NumLote#"
                    Form="yes"
					formName="formX"
					form_method="post"
					showEmptyListMsg="yes"
					keys="ERid"	
					MaxRows="15"
					checkboxes="N"
					navegacion="#navegacion#"
				/>		
          
            <cfelse>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#rsSQL#"
					columnas="ERid,NumDeposito,CBdescripcion,FCid,MntEfectivo,MntCheque,Fremesa"
					desplegar="NumDeposito,CBdescripcion,MntEfectivo+MntCheque,Fremesa"
					etiquetas="Numero Depósito,Cuenta Bancaria,Monto Total, Fecha"
					formatos="S,S,M,D"
					align="left,left,left,left"
					ira="InclusionRemesas.cfm"
                    Form="yes"
					formName="formX"
					form_method="post"
					showEmptyListMsg="yes"
					keys="ERid"	
					MaxRows="15"
					checkboxes="N"
					navegacion="#navegacion#"
				/>	
                
                </cfif>					
			</td>
		</tr>
      <tr>
      <form name="form2" method="post" action="InclusionRemesas.cfm">
    <cfif isdefined('url.NumLote')>
    <cfoutput>
     <input type="hidden" name="NumLote" value="#url.NumLote#" />
    </cfoutput>
     </cfif>
     
           <td colspan="4" align="center">
               <input type="submit" name="Nuevo" value="Nuevo" />		
            </td>
            </tr>
     </form>
	</table>

<script language="javascript" type="text/javascript">
</script>

