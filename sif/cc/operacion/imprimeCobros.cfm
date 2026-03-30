<cfif isdefined('CCTcodigo') and len(trim(#url.CCTcodigo#)) gt 0 and isdefined('Pcodigo') and len(trim(#url.Pcodigo#)) gt 0> 
        <cfquery name="rsCobros" datasource="#session.DSN#">
			select a.Pcodigo,a.Pfecha,coalesce(cf.CFdescripcion,'--') as CFdescripcion,sn.SNnombre, sn.SNidentificacion,o.Odescripcion,m.Mnombre,*
			from HPagos a 
            left outer join  CFuncional cf
                on a.CFid = cf.CFid
                and a.Ecodigo = cf.Ecodigo
            inner join SNegocios sn
                on a.SNcodigo = sn.SNcodigo
                and a.Ecodigo = sn.Ecodigo
            inner join Oficinas o 
                on a.Ocodigo = o.Ocodigo
                and a.Ecodigo = o.Ecodigo
            inner join Monedas m
               on a.Mcodigo = m.Mcodigo
               and a.Ecodigo = m.Ecodigo        
			where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
			  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
              and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Pcodigo#">
		</cfquery> 
        <cfquery name="rsEmpresa" datasource="#session.dsn#">
          select Edescripcion from Empresas where Ecodigo = #session.Ecodigo#
        </cfquery>       
        <table align="center" width="90%" border="0" bordercolor="#999999" cellpadding="0" cellspacing="0">
        <tr>
            <td colspan="4" align="center"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong><hr /></td>
        </tr>
        <tr>
            <td colspan="4" align="center"><strong>Factura de Cobro</strong><hr /></td>
        </tr>
        <tr>
            <td><strong>Documento:</strong></td>
            <td align="left"><cfoutput>#rsCobros.Pcodigo#</cfoutput></td>
            <td><strong>Fecha Documento:</strong></td>
            <td align="left"><cfoutput>#lsdateformat(rsCobros.Pfecha,'dd-mm-YYYY')#</cfoutput></td>           
        </tr>
        <tr>
            <td><strong>Centro Funcional:</strong></td>
            <td align="left"><cfoutput>#rsCobros.CFdescripcion#</cfoutput></td>
            <td><strong>Oficina:</strong></td>
            <td align="left"><cfoutput>#rsCobros.Odescripcion#</cfoutput></td>

        </tr>
         <tr>
            <td><strong>Socio Negocios:</strong></td>
            <td align="left"><cfoutput>#rsCobros.SNnombre#</cfoutput></td>
            <td><strong>Identificación:</strong></td>
            <td align="left"><cfoutput>#rsCobros.SNidentificacion#</cfoutput></td>
        </tr>    
        <tr>
            <td><strong>Moneda:</strong></td>
            <td align="left"><cfoutput>#rsCobros.Mnombre#</cfoutput></td>
            <td><strong>Tipo Cambio:</strong></td>
            <td align="left"><cfoutput>#lsnumberformat(rsCobros.Ptipocambio,'9,99.99')#</cfoutput></td>            
        </tr>
        <tr>
           <td colspan="2">&nbsp;</td>
           <td><strong>Total:</strong></td>
           <td align="left"><cfoutput>#lsnumberformat(rsCobros.Ptotal,'9,99.99')#</cfoutput></td>
        </tr>
        <tr>
            <td><strong>Descrión Alterna:</strong></td>
            <td colspan="3"><cfoutput>#rsCobros.Preferencia#</cfoutput></td>
        </tr>   
        <tr>
            <td colspan="4">&nbsp;</td>            
        </tr>          
        </table>
        <table align="center" border="0">
        <cfif not isdefined('imprimir')>
             <tr>
                <td colspan="4" align="center"><input type="button" value="Regresar" onclick="irAtras()" /></td>            
            </tr>  
        </cfif>
        </table>
  <script language="javascript">
   function irAtras()
   {
	 window.location= "ListaPagos.cfm";  
   }
  </script>      
</cfif>        