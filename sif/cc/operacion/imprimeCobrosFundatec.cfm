<title>Cobros CxC</title>
<cfif isdefined('CCTcodigo') and len(trim(#url.CCTcodigo#)) gt 0 and isdefined('Pcodigo') and len(trim(#url.Pcodigo#)) gt 0 and len(trim(#url.documento#)) gt 0 >
  <cfquery name="rsCobros" datasource="#session.DSN#">
			select a.Pcodigo,a.Pfecha,coalesce(cf.CFdescripcion,'--') as CFdescripcion,sn.SNnombre, sn.SNidentificacion,o.Odescripcion,m.Mnombre,a.Ptotal,a.*
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

        <cfquery name="rsBMov" datasource="#session.dsn#">
           select DRdocumento,* from BMovimientos where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#"> and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCobros.Pcodigo#">
              and DRdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.documento#">
        </cfquery>   
        <cfquery name="rsDocumento" datasource="#session.dsn#">
           select ETnumero, FCid from HDocumentos where Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.documento#">
        </cfquery>   
 
        <cfif isdefined('rsDocumento') and rsDocumento.recordcount gt 0 and len(trim(#rsDocumento.ETnumero#)) gt 0 and len(trim(#rsDocumento.FCid#)) gt 0>
           <cfquery name="rsFactura" datasource="#session.dsn#">
            select DTdescripcion,DTcant,m.Mnombre,m.Miso4217, ETobs,* 
               from ETransacciones a 
                     inner join DTransacciones b
                       on a.FCid = b.FCid
                      and a.ETnumero = b.ETnumero
                      and a.Ecodigo = b.Ecodigo
                     inner join Monedas m
                       on a.Mcodigo = m.Mcodigo
                      and a.Ecodigo = m.Ecodigo   
             where a.ETnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocumento.ETnumero#">
             and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.FCid#">
           </cfquery>                
        </cfif>      
        
<cfquery name="rsEmpresa" datasource="#session.dsn#">
          select Edescripcion,EIdentificacion,ETelefono1, ETelefono2,EDireccion2, ts_rversion from Empresas where Ecodigo = #session.Ecodigo#
        </cfquery>       
        <table align="center" width="90%" border="0" bordercolor="#999999" cellpadding="0" cellspacing="0">
        <tr>
             <td align="center" width="10%"><cfinvoke 
					 component="sif.Componentes.DButils"
					 method="toTimeStamp"
					 returnvariable="tsurl" arTimeStamp="#rsEmpresa.ts_rversion#"> </cfinvoke>
					<cfoutput> 
						<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" class="iconoEmpresa" alt="logo" border="0" height="100" width="150" />
			</cfoutput></td>
            <td colspan="3" align="left"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong><br />
            C&eacute;dula Jur&iacute;dica:&nbsp;<cfoutput>#rsEmpresa.EIdentificacion#</cfoutput><br />
            Email:&nbsp;<cfoutput>#rsEmpresa.EDireccion2#</cfoutput><br />
            Tel&eacute;fono:&nbsp;<cfoutput>#rsEmpresa.ETelefono1#</cfoutput><br />
            Fax:&nbsp;<cfoutput>#rsEmpresa.ETelefono2#</cfoutput>
            </td>
        </tr>
        <tr>
           <td colspan="4">
               <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#333333" align="center">
                  <tr> <td>
                           <table border="0" align="center" width="100%">
                               <tr> 
                                   <td width="50%" height="39"><strong>&nbsp;RECIBO No:</strong></td>
                                   <td><strong>FECHA:</strong><cfoutput>#lsdateformat(Now(),'dd-mm-YYYY')#</cfoutput></td>
                               </tr>
                           </table> 
                       </td>                    
                  </tr>
               </table> 
           </td> 
        </tr>
        <tr>
           <td colspan="4" height="1px"></td>          
        </tr>
        <tr>
            <td colspan="4">
               <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#333333">
                <tr>
                    <td width="50%">
                        <table border="0" width="100%" border="1" align="center">
                          <tr>
                             <td><strong>&nbsp;C&oacute;digo:</strong></td><td width="50%"><cfoutput>#rsCobros.Pcodigo#</cfoutput></td>
                          </tr>   
                          <tr>
                             <td><strong><strong>Recibimos de:</strong></td><td><cfoutput>#rsCobros.SNnombre#</cfoutput></td>
                          </tr>
                          <tr>   
                             <td><strong>La cantidad de </strong></td><td><cfoutput>#rsFactura.DTcant#</cfoutput></td>
                          </tr> 
                          <tr>   
                             <td><strong>Por concepto de </strong></td><td><cfoutput>#rsFactura.DTdescripcion#</cfoutput></td>
                          </tr>                  
                          <tr>   
                             <td><strong>Observaci&oacute;n:</strong></td><td><cfif isdefined('rsFactura.ETobs') and len(trim(#rsFactura.ETobs#)) gt 0><cfoutput>#rsFactura.ETobs#</cfoutput><cfelse>---</cfif></td>
                          </tr> 
                          <tr>   
                             <td><strong>Efectivo:</strong></td><td><cfoutput>#lsnumberformat(rsCobros.Ptotal,'9,99.99')# #rsFactura.Miso4217#</cfoutput></td>
                          </tr> 
                        </table>
                     </td> 
                </tr>
               </table> 
           </td>          
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