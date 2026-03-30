<cf_templateheader title="Consultas Administrativas">
	<cfif not isdefined("Form.SNcodigo")>
        <cfif isdefined("Url.SNcodigo")>
            <cfparam name="Form.SNcodigo" default="#Url.SNcodigo#">
        <cfelse>
            <cfparam name="Form.SNcodigo" default="-1">
        </cfif>
    </cfif>
    <cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo)) EQ 0>
        <cfparam name="Form.SNcodigo" default="-1">
    </cfif>
    <cfif isdefined("url.tab") and not isdefined("form.tab")>
        <cfset form.tab = url.tab >
    </cfif>
    
    <cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5', form.tab) )>
        <cfset form.tab = 1 >
    </cfif>	


	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Liberaci&oacute;n de Transacciones de Punto de Venta'>
	
	<style type="text/css">
        .encabReporte {
            background-color: #006699;
            font-weight: bold;
            color: #FFFFFF;
            padding-top: 5px;
            padding-bottom: 5px;
            padding-left: 5px;
            padding-right: 5px;
        }
        .tbline {
            border-width: 1px;
            border-style: solid;
            border-color: #CCCCCC;
        }
    </style>

	<cfquery name="rsMonedas" datasource="#session.dsn#">
		Select f.Mcodigo,Mnombre,Miso4217
		from FAP002 f
			inner join Monedas m
				on m.Ecodigo=f.Ecodigo
					and m.Mcodigo=f.Mcodigo
		where f.Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and FAP02FAC=1
	</cfquery>

    <cfquery name="rsSocios" datasource="#session.dsn#">
        select SNcodigo, SNnombre, SNidentificacion, DEidVendedor, DEidCobrador, SNcuentacxp, SNvenventas, SNid
        from SNegocios a, EstadoSNegocios b
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
          and a.ESNid = b.ESNid	
          <cfif isdefined('Form.SNnumero') and len(trim(Form.SNnumero))>
            and a.SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#"> 
          </cfif>
          <cfif isdefined('Form.SNcodigo') and len(trim(Form.SNcodigo))>
            and a.SNcodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> 
          </cfif>
          <cfif isdefined('Form.SNidentificacion') and len(trim(Form.SNidentificacion))>
            and a.SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNidentificacion#"> 
          </cfif>
          and a.SNtiposocio in ('A', 'C')
    </cfquery> 

	<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo)) NEQ 0 and Form.SNcodigo NEQ -1>
        <cfquery name="rsSocioDatos" datasource="#session.dsn#">
            select coalesce(SNnombre,'') as SNnombre,
                   coalesce(SNidentificacion, '') as SNidentificacion,
                   coalesce(SNdireccion, 'No Tiene') as SNdireccion,
                   coalesce(SNtelefono, 'No Tiene') as SNtelefono,
                   coalesce(SNFax, 'No Tiene') as SNFax,
                   coalesce(SNemail, 'No Tiene') as SNemail,
                   (case SNtipo when 'F' then 'Física' when 'J' then 'Jurídica' when 'E' then 'Extranjero' else '???' end) as SNtipo,
                   SNid as SNid,
                   SNnumero as SNnumero,
                   SNcodigo
            from SNegocios 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and SNtiposocio in ('A', 'C')
            and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
            order by SNnombre
        </cfquery>
    </cfif>

	<cfif isdefined("Session.modulo") and Session.modulo EQ "Admin">
        <cfinclude template="../../portlets/pNavegacionAdmin.cfm">
    <cfelseif isdefined("Session.modulo") and Session.modulo EQ "CC">
        <cfinclude template="../../portlets/pNavegacionCC.cfm">
    </cfif>
    <script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>
     <form action="LibTranPV-sql.cfm" method="post" name="form2">
      <table width="100%" border="0">
        <tr> 
          <td colspan="5" nowrap> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td colspan="5" align="right" style="padding-right: 5px">&nbsp;</td>
              </tr>

                <td align="right" style="padding-right: 5px">Cliente</td>
                <td>
                <cfif isdefined('form.SNcodigo') and LEN(trim(form.SNcodigo)) and form.SNcodigo neq -1>
                    <cf_sifsociosnegocios2 SNtiposocio="C"  size="50" idquery="#rsSocios.SNcodigo#" form="form2" tabindex="1">
                <cfelse>
                    <cf_sifsociosnegocios2 SNtiposocio="C"  size="50" frame="frame1" form="form2" tabindex="1">
                </cfif>
                
                </td>
                <td><input name="btnConsultar" type="button" value="Consultar" tabindex="1" onclick="FuncConsultar();"></td>
                <td>&nbsp; 
                    
                </td>
                <td width="50%">&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
       
        <cfif isdefined("Form.SNcodigo") and Form.SNcodigo NEQ -1  and len(trim(Form.SNcodigo)) NEQ 0>
        <tr> 
          <td colspan="5">
            <cfoutput query="rsSocioDatos">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr align="center"> 
                    <td class="tituloAlterno" colspan="6">#SNnombre#</td>
                  </tr>
                  <tr> 
                    <td style="padding-left: 5px; font-weight: bold;">Identificaci&oacute;n:</td>
                    <td style="padding-left: 5px;">#SNidentificacion#</td>
                    <td style="padding-left: 5px; font-weight: bold;">Persona:</td>
                    <td style="padding-left: 5px;">#SNtipo#</td>
                    <td style="padding-left: 5px; font-weight: bold;">Email:</td>
                    <td style="padding-left: 5px;">#SNemail#</td>
                  </tr>
                  <tr> 
                    <td style="padding-left: 5px; font-weight: bold;">Direcci&oacute;n:</td>
                    <td style="padding-left: 5px;">#SNdireccion#</td>
                    <td style="padding-left: 5px; font-weight: bold;">Tel&eacute;fono:</td>
                    <td style="padding-left: 5px;">#SNtelefono#</td>
                    <td style="padding-left: 5px; font-weight: bold;">Fax:</td>
                    <td style="padding-left: 5px;">#SNfax#</td>
                  </tr>
                </table>
            </cfoutput>
          </td>
        </tr>
        </cfif>
      </table>
     </form>
	<!--- Aqui el tab --->
    <cfif isdefined("Form.SNcodigo") and Form.SNcodigo NEQ -1  and len(trim(Form.SNcodigo)) NEQ 0>
        <cf_tabs width="100%" onclick="tab_set_current_doc">
            <cf_tab text="Gr&aacute;fico" selected="#form.tab eq 1#" id = "1">
                <cfif Form.tab EQ 1>
                    <cfinclude template="LibTranGraphPV.cfm"> 
                </cfif>	
            </cf_tab>
            <cf_tab text="Transacciones POS" selected="#form.tab eq 2#" id = "2">
                <cfif Form.tab EQ 2>
                    <cfinclude template="LibTranPOSPV.cfm"> 
                </cfif>	
            </cf_tab>
            <cf_tab text="Hist&oacute;rico de Liberaciones" selected="#form.tab eq 3#" id = "3">
                <cfif Form.tab EQ 3>
                    <cfinclude template="LibTranHistPV.cfm"> 
                </cfif>	
            </cf_tab>
        </cf_tabs>
    </cfif>

           
            	
		<cf_web_portlet_end>
		<script type="text/javascript">
		<!--
		function tab_set_current_doc (n){
			<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
				location.href='LibTranPV.cfm?SNcodigo=<cfoutput>#JSStringFormat(form.SNcodigo)#</cfoutput>&tab='+escape(n);
			<cfelse>
				alert('Debe seleccionar un Cliente.');
			</cfif>
		}
		function FuncConsultar(){
			document.form2.submit();
		}
		//-->
	</script>
<cf_templatefooter>