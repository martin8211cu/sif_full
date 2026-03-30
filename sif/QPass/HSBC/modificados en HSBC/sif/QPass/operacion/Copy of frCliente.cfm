<!--- No quitar ningún comentario de este fuente --->

<cfset LvarDireccionUri=fnObtieneDireccionWS()>
<cfdump var="#LvarDireccionUri#">
<cfif isdefined("url.CTEidentificacion") and isdefined("url.CTEtipo")>

	<cfif len(trim(url.CTEidentificacion)) eq 0>
		<cfset url.CTEidentificacion = -1>
	</cfif>

	<cfif len(trim(url.CTEtipo)) eq 0>
		<cfset url.CTEtipo = -1>
	</cfif>

	<!--- Trama de invocación NO OCUPA USUARIO NI PASSWORD:			
		http://svrdes04/SolicitudSConsultasWS?
			<CONSULTACTASCTESOLICITUD>
				<CANAL>QPass</CANAL>
				<IDTRANSACCIONCANAL>0</IDTRANSACCIONCANAL>
				<ENTE>0</ENTE>
				<NUMMAESTRO>{identificacion del cliente}</NUMMAESTRO>
				<TARJETA>0</TARJETA>
				<PRODUCTO>0</PRODUCTO>
			</CONSULTACTASCTESOLICITUD> 
	--->

        <cfset LvarXML="<CONSULTACTASCTESOLICITUD><CANAL>QUICKPASS</CANAL><IDTRANSACCIONCANAL>22</IDTRANSACCIONCANAL><ENTE>0</ENTE><NUMMAESTRO>#url.CTEidentificacion#</NUMMAESTRO><TARJETA>0</TARJETA><PRODUCTO>QUP</PRODUCTO></CONSULTACTASCTESOLICITUD>">
	<!--- <cfset LvarURI=LvarDireccionUri&"?x=#URLEncodedFormat(LvarXML)#"> --->

        <cfset LvarURI="<CONSULTACTASCTESOLICITUD><CANAL>QUICKPASS</CANAL><IDTRANSACCIONCANAL>0</IDTRANSACCIONCANAL><ENTE>0</ENTE><NUMMAESTRO>#url.CTEidentificacion#</NUMMAESTRO><TARJETA>0</TARJETA><PRODUCTO>QUP</PRODUCTO></CONSULTACTASCTESOLICITUD>">
	<!--- <cfdump var="#URLDecode(LvarURI)#"> --->

	<cfset LvarBanderaWS = false>
	<cfset selectedElements ='7'> <!--- Se inicializa en 7 para tener un valor. --->
	<cftry>
		<cfhttp method="post" timeout ="3" url="#LvarDireccionUri#" result="LvarXMLres" throwonerror="yes" charset="utf-8">
			<cfhttpparam name="x" type="XML" value="#LvarURI#">
		</cfhttp>

		<!---Funciona con url explicita
		<cfhttp method="post" timeout ="3" url="http://svrdes04/SolicitudSConsultasWS" result="LvarXMLres" throwonerror="yes" charset="utf-8">
			<cfhttpparam name="x" type="XML" value="<CONSULTACTASCTESOLICITUD><CANAL>QUICKPASS</CANAL><IDTRANSACCIONCANAL>22</IDTRANSACCIONCANAL><ENTE>0</ENTE><NUMMAESTRO>#url.CTEidentificacion#</NUMMAESTRO><TARJETA>0</TARJETA><PRODUCTO>QUP</PRODUCTO></CONSULTACTASCTESOLICITUD>">
		</cfhttp>--->


		<cfxml variable="MyDoc">
        		<cfoutput>#LvarXMLres.Filecontent#</cfoutput>
		</cfxml> <!--- <cf_dump var="#MyDoc#"> --->

		<cfset selectedElements = XmlSearch(MyDoc, "/CONSULTACTASCTERESPUESTA/CUENTAS/CUENTA")>
		<cfif arraylen(selectedElements) gt 0>
			<cfset LvarBanderaWS = true>
		</cfif>

		<cfcatch type="any">
			<!--- <cfthrow detail ="#cfcatch.message# #cfcatch.detail#"> --->
			<cfset LvarBanderaWS = false> 
		</cfcatch>
    	</cftry>


	<cfif not LvarBanderaWS>

		<cfquery name="rsBuscaCliente" datasource="#session.dsn#">
			select 
				a.QPcteNombre,
				a.QPcteDireccion,
				a.QPcteTelefono1,
				a.QPcteTelefono2,
				a.QPcteTelefonoC,
				a.QPcteCorreo
			from QPcliente a
				inner join QPtipoCliente b
				on b.QPtipoCteid = a.QPtipoCteid
			where a.Ecodigo = #session.Ecodigo#
			and a.QPtipoCteid = #url.CTEtipo#
			and a.QPcteDocumento = '#url.CTEidentificacion#'
		</cfquery>

		<cfif rsBuscaCliente.recordcount gt 0>

			<cfoutput>
				<script language="javascript" type="text/javascript">
					var HTML = "<span id='Contenedor_cuenta'>";
					HTML += "<input name='QPctaBancoNum'  type='text' value='' tabindex='1' maxlength='30' />";
					HTML += "</span>";
					window.parent.document.getElementById("Contenedor_cuenta").innerHTML = HTML;
				</script>
			</cfoutput>
            <!--- Si encuentra el cliente en SOIN es por que el WS no encontró al cliente o estaba caido, por lo tanto se muestran solo conveios de prepago. --->
            <!--- Busca todos los convenios de Prepago Vigentes --->
            <cfquery name="rsConvenio" datasource="#session.DSN#">
                select 
                    QPvtaConvid,
                    QPvtaConvCod,
                    QPvtaConvDesc,
                    QPvtaConvTipo
                from QPventaConvenio
                where Ecodigo = #session.Ecodigo#
                    and <cf_dbfunction name="today"> between <cf_dbfunction name="to_date00" args="QPvtaConvFecIni"> and <cf_dbfunction name="to_date00" args="QPvtaConvFecFin">
                    and QPvtaConvTipo = 2
                order by QPvtaConvDesc
            </cfquery>
            <cfoutput>
                <script language="javascript" type="text/javascript">
                    var HTML = "<span id='contenedor_convenio'>";
                    HTML += "<select name='QPvtaConvid' tabindex='1' onchange='ajaxFunction_Convenio()'>";
                    <cfloop query="rsConvenio">
                        HTML += "<option value='#rsConvenio.QPvtaConvid#'>#rsConvenio.QPvtaConvCod# - #rsConvenio.QPvtaConvDesc#</option>";
                    </cfloop>
                    HTML += "</select>";
                    HTML += "</span>";
                    window.parent.document.getElementById("contenedor_convenio").innerHTML = HTML;
                    window.parent.ajaxFunction_Convenio();
                </script>
            </cfoutput>
            
			<cfoutput>
				<script language="javascript" type="text/javascript">
					window.parent.document.form1.QPcteNombre.value = "#rsBuscaCliente.QPcteNombre#";
					<!--- window.parent.document.form1.QPcteNombre.readOnly = "false"; --->
					window.parent.document.form1.QPcteDireccion.value = "#rsBuscaCliente.QPcteDireccion#";
					window.parent.document.form1.QPcteTelefono1.value = "#rsBuscaCliente.QPcteTelefono1#";
					window.parent.document.form1.QPcteTelefono2.value = "#rsBuscaCliente.QPcteTelefono2#";
					window.parent.document.form1.QPcteTelefonoC.value = "#rsBuscaCliente.QPcteTelefonoC#";
					window.parent.document.form1.QPcteCorreo.value = "#rsBuscaCliente.QPcteCorreo#";

					window.parent.document.form1.QPvtaTagFecha.focus();

				</script>
			</cfoutput>
		</cfif>

	</cfif>


	<cfif LvarBanderaWS>
    	<!--- Nunca Eliminar el pintado de los datos para poder debuguear facilmente en caso necesario --->
		<table>
			<tr>
		                <td>PRODUCTO</td>
		                <td>CTABANCO</td>
		                <td>CLIENTE</td>
			        	<td>NOMBRECTE</td>
		                <td>MONEDA</td>
		                <td>CTACLIENTE</td>
		                <td>ESTADOCTA</td>
		                <td>DISPONIBLE</td>
		                <td>TIPOTARJETA</td>
		                <td>FECHACORTE</td>
		                <td>FECHAPAGO</td>
		                <td>SALDOULTCORCOL</td>
		                <td>DEBITOSCOL</td>
		                <td>CREDITOSCOL</td>
		                <td>PAGOMINCOL</td>
		                <td>PAGOCONTCOL</td>
		                <td>SALDOULTCORDOL</td>
		                <td>DEBITOSDOL</td>
		                <td>CREDITOSDOL</td>
		                <td>PAGOMINDOL</td>
		                <td>PAGOCONTDOL</td>
		                <td>LIMITECR</td>
			</tr>
            <cfset LvarCuenta = ''>
			<cfloop index="i" from="1" to="#ArrayLen(selectedElements)#">
				<tr>
		
					<cfoutput>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].PRODUCTO.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].CTABANCO.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].CLIENTE.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].NOMBRECTE.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].MONEDA.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].CTACLIENTE.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].ESTADOCTA.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].DISPONIBLE.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].TIPOTARJETA.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].FECHACORTE.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].FECHAPAGO.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].SALDOULTCORCOL.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].DEBITOSCOL.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].CREDITOSCOL.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].PAGOMINCOL.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].PAGOCONTCOL.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].SALDOULTCORDOL.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].DEBITOSDOL.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].CREDITOSDOL.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].PAGOMINDOL.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].PAGOCONTDOL.XMLtext#</td>
                        <td>#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].LIMITECR.XMLtext#</td>
					</cfoutput>
                    <cfset LvarCuenta 		= LvarCuenta & #MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].PRODUCTO.XMLtext#&'-'&#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].CTABANCO.XMLtext#
					& '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/ ' & #numberformat(MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].DISPONIBLE.XMLtext, ',9.00')#
					& ' - ' & #MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[i].MONEDA.XMLtext#>
                    <cfif i LT #ArrayLen(selectedElements)#>
                    	<cfset LvarCuenta = LvarCuenta & '|'>
                    </cfif>
				</tr>
				<cfset i = i + 1>
			</cfloop><cfoutput>#LvarCuenta#</cfoutput>
		</table>
        
		<cfoutput>
			<script language="javascript" type="text/javascript">
				var HTML = "<span id='Contenedor_cuenta'>";
				HTML += "<select name='QPctaBancoNum'>";
				<cfloop list="#LvarCuenta#" delimiters="|" index="i">
					HTML += "<option value='#i#'>#i#</option>";
				</cfloop>
				HTML += "</select>";
				HTML += "</span>";
				window.parent.document.getElementById("Contenedor_cuenta").innerHTML = HTML;
			</script>
		</cfoutput>
        <!--- Muestra todos los convenios de prepago y postpago vigentes --->
        <cfquery name="rsConvenio" datasource="#session.DSN#">
            select 
                QPvtaConvid,
                QPvtaConvCod,
                QPvtaConvDesc,
                QPvtaConvTipo
            from QPventaConvenio
            where Ecodigo = #session.Ecodigo#
                and <cf_dbfunction name="today"> between <cf_dbfunction name="to_date00" args="QPvtaConvFecIni"> and <cf_dbfunction name="to_date00" args="QPvtaConvFecFin">
            order by QPvtaConvDesc
        </cfquery>
        <cfoutput>
            <script language="javascript" type="text/javascript">
                var HTML = "<span id='contenedor_convenio'>";
                HTML += "<select name='QPvtaConvid' tabindex='1' onchange='ajaxFunction_Convenio()'>";
                <cfloop query="rsConvenio">
                    HTML += "<option value='#rsConvenio.QPvtaConvid#'>#rsConvenio.QPvtaConvCod# - #rsConvenio.QPvtaConvDesc#</option>";
                </cfloop>
                HTML += "</select>";
                HTML += "</span>";
                window.parent.document.getElementById("contenedor_convenio").innerHTML = HTML;
				window.parent.ajaxFunction_Convenio();
            </script>
        </cfoutput>

		<!--- Acá va el procesamiento del webservice en el caso que devuelva la información requerida --->

		<cfoutput>
			<script language="javascript" type="text/javascript">
				window.parent.document.form1.QPcteNombre.value = "#MyDoc.CONSULTACTASCTERESPUESTA.CUENTAS.CUENTA[1].NOMBRECTE.XMLtext#";
				<!--- window.parent.document.form1.QPcteNombre.readOnly = "true"; --->
				
				window.parent.document.form1.QPcteDireccion.value = "";
				window.parent.document.form1.QPcteTelefono1.value = "";
				window.parent.document.form1.QPcteTelefono2.value = "";
				window.parent.document.form1.QPcteTelefonoC.value = "";
				window.parent.document.form1.QPcteCorreo.value = "";
				window.parent.document.form1.QPcteNombre.focus();
			</script>
		</cfoutput>    

	</cfif> 
	
	<cfif not LvarBanderaWS and isdefined("rsBuscaCliente") and rsBuscaCliente.recordcount EQ 0>
               <!--- Solo limpia los valores si no encontró el cliente en SOIN o en HSBC --->

		<cfoutput>
			<script language="javascript" type="text/javascript">
				var HTML = "<span id='Contenedor_cuenta'>";
				HTML += "<input name='QPctaBancoNum'  type='text' value='' tabindex='1' maxlength='30' />";
				HTML += "</span>";
				window.parent.document.getElementById("Contenedor_cuenta").innerHTML = HTML;
			</script>
		</cfoutput>
        <!--- Busca todos los convenios de Prepago Vigentes --->
        <cfquery name="rsConvenio" datasource="#session.DSN#">
            select 
                QPvtaConvid,
                QPvtaConvCod,
                QPvtaConvDesc,
                QPvtaConvTipo
            from QPventaConvenio
            where Ecodigo = #session.Ecodigo#
                and <cf_dbfunction name="today"> between <cf_dbfunction name="to_date00" args="QPvtaConvFecIni"> and <cf_dbfunction name="to_date00" args="QPvtaConvFecFin">
                and QPvtaConvTipo = 2
            order by QPvtaConvDesc
        </cfquery>
        <cfoutput>
            <script language="javascript" type="text/javascript">
                var HTML = "<span id='contenedor_convenio'>";
                HTML += "<select name='QPvtaConvid' tabindex='1' onchange='ajaxFunction_Convenio()'>";
                <cfloop query="rsConvenio">
                    HTML += "<option value='#rsConvenio.QPvtaConvid#'>#rsConvenio.QPvtaConvCod# - #rsConvenio.QPvtaConvDesc#</option>";
                </cfloop>
                HTML += "</select>";
                HTML += "</span>";
                window.parent.document.getElementById("contenedor_convenio").innerHTML = HTML;
				window.parent.ajaxFunction_Convenio();
            </script>
        </cfoutput>
		<cfoutput>
			<script language="javascript" type="text/javascript">
				window.parent.document.form1.QPcteNombre.value = "";
				<!--- window.parent.document.form1.QPcteNombre.readOnly = "false"; --->
				window.parent.document.form1.QPcteDireccion.value = "";
				window.parent.document.form1.QPcteTelefono1.value = "";
				window.parent.document.form1.QPcteTelefono2.value = "";
				window.parent.document.form1.QPcteTelefonoC.value = "";
				window.parent.document.form1.QPcteCorreo.value = "";

				window.parent.document.form1.QPcteNombre.focus();
			</script>
		</cfoutput>

	</cfif>
</cfif>

<cffunction name="fnObtieneDireccionWS" access="private" output="no" returntype="string">
	<cfif isdefined("application.HSBCWSAddress")>
		<cfreturn application.HSBCWSAddress>
	</cfif>
	<cfquery name="_rsObtieneRutaWS" datasource="#session.dsn#">
		select Pvalor
		from QPParametros 
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 30
	</cfquery>

	<cfif _rsObtieneRutaWS.recordcount EQ 1 and len(trim(_rsObtieneRutaWS.Pvalor)) GT 10>
		<cfset application.HSBCWSAddress = _rsObtieneRutaWS.Pvalor>
		<cfreturn application.HSBCWSAddress>
	</cfif>

	<cfif session.Ecodigo eq 1>
		<cfreturn "http://127.0.0.1:8300/cfmx/home/public/SolicitudSConsultasWS.cfm">
	<cfelse>
		<cfreturn "http://svrdes04/SolicitudSConsultasWS">
	</cfif>
</cffunction>