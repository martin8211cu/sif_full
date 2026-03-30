<!--- Sincronizacion de Socios de Negocios a LDCOM Interfaz LD-SIF Ver. 1.0 --->
<!--- Este componente crea y actualiza la informacion de los socios de negocios de SIF en el sistema LDCOM--->
<cfcomponent extends="Interfaz_Base">
<cffunction name="EjecutaWS" access="public" returntype="string" output="yes">

<cflog file="Sincronizacion_Clientes_WS" application="no" text="Inicia proceso sincronizacion de clientes, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
	<!--- Obtiene las empresas a sincronizar --->
	<cfquery name="rsEmpresas" datasource="sifinterfaces">
		select EQUcodigoOrigen,EQUidSIF, EQUdescripcion, EQUempSIF
		from SIFLD_Equivalencia 
		where CATcodigo like 'CADENA'
		and SIScodigo like 'LD'
		<cfif  isdefined('session.Ecodigo') and Session.Ecodigo NEQ 0>
			and   EQUidSIF = '#session.Ecodigo#'
		</cfif>
	</cfquery>

	<cfquery name="rsGetWsdlWS" datasource="sifinterfaces">
		SELECT Pvalor
		FROM SIFLD_ParametrosAdicionales
		WHERE Pcodigo = '00001'
	</cfquery>

	<cfif isdefined("rsGetWsdlWS") AND rsGetWsdlWS.recordcount EQ 0>
		<cflog file="Sincronizacion_Clientes_WS"
			   application="no"
			   text="La URL del WSDL del WS Sincronizacion de clientes, no esta definido en Parametros adicionales, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
	</cfif>


	<!--- <cfif not isdefined('session.Ecodigo')>
		<cfset varEcodigo = 2>
	<cfelse>
		<cfset varEcodigo = 2>
	</cfif> --->
	
	<cfif isdefined("rsEmpresas") and rsEmpresas.recordcount GT 0 AND isdefined("rsGetWsdlWS") AND rsGetWsdlWS.recordcount GT 0>
	
	<cfloop query="rsEmpresas"> <!---Abre loop empresa--->
<!--- 		<cfset session.dsn = getConexion(rsEmpresas.EQUidSIF)> --->
		<cfset session.dsn = getConexion(rsEmpresas.EQUidSIF)>
		<cfset varEcodigo = rsEmpresas.EQUempSIF>

		<cfif len(#session.dsn#) EQ 0>
			<cfset session.dsn = "minisif">
		</cfif>

		<!--- Extrae los socios de negocios --->
		<cfquery name="rsSocio" datasource="#session.dsn#">
			select sn.Ecodigo, sn.SNcodigo, sn.SNid, 
			left(LTRIM(RTRIM(replace(replace(sn.SNidentificacion,'',''),'-',''))),15) SNidentificacion, sn.SNtipo,
			left(LTRIM(RTRIM(sn.SNnombre)),100) SNnombre,  left(LTRIM(RTRIM(sn.SNdireccion)),100) SNdireccion, sn.Ppais, 
			left(sn.SNtelefono,15) SNtelefono, left(sn.SNFax,15) SNFax, sn.SNemail,
			sn.SNcodigoext, sn.SNtiposocio, isnull(sn.SNplazoentrega,0) as SNplazoentrega,
			isnull(sn.SNplazocredito,0) as SNplazocredito, sn.Mcodigo, sn.intfazLD,sn.sincIntfaz,
			isnull(sn.SNmontoLimiteCC,0) as SNmontoLimiteCC, ds.codPostal,
			isnull(sn.saldoCliente,0) as SaldoSN,
            isnull(sn.saldoCliente,0) as SaldoCliente, getdate() as fecha,
            isnull(sn.SNvencompras,0) as SNvencompras, sn.id_direccion,sn.SNidentificacion2, sn.SNinactivo
			from SNegocios sn
			inner join DireccionesSIF ds
				on sn.id_direccion = ds.id_direccion
			where sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
			and sn.SNcodigo != 9999
			<!--- Unicamente: Sincroniza Interfaz --->
			AND sn.sincIntfaz = 1
			and SNtiposocio in ('C','A','P')
		</cfquery>
		
		<cfif isdefined("rsSocio") and rsSocio.recordcount GT 0>
        <cfloop query="rsSocio"> <!---Abre loop socio--->
			<!--- PAIS --->
			<cfquery name="rsEquivalencia" datasource="sifinterfaces">
				select max(EQUcodigoOrigen) as EQUcodigoOrigen
				from SIFLD_Equivalencia
				where CATcodigo like 'PAIS'
				and EQUempSIF =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpresas.EQUidSIF#">
				and EQUidSIF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.Ppais#">
			</cfquery>

			<cfif isdefined("rsEquivalencia") and rsEquivalencia.recordcount GT 0 and len(rsEquivalencia.EQUcodigoOrigen) GT 0>
				<cfset LvarPais = rsEquivalencia.EQUcodigoOrigen>
			<cfelse>
				<cfthrow message="No se ha definido la equivalencia para el Pais:#rsSocio.Ppais# en la Empresa:#rsEmpresas.EQUdescripcion#">
			</cfif>

			<!--- MONEDA --->
			<cfquery name="rsEquivalencia" datasource="sifinterfaces">
				select max(EQUcodigoOrigen) as EQUcodigoOrigen
				from SIFLD_Equivalencia
				where CATcodigo like 'MONEDA'
				and EQUempSIF like  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpresas.EQUidSIF#">
				and EQUidSIF like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.Mcodigo#">
			</cfquery>
			<cfif len(rsEquivalencia.EQUcodigoOrigen)>
				<cfset LvarMoneda = rsEquivalencia.EQUcodigoOrigen>
			<cfelse>
				<cfthrow message="Error de Sincronizacion. No se ha definido la equivalencia para la Moneda:#rsSocio.Mcodigo# en la Empresa:#rsEmpresas.EQUdescripcion#">
			</cfif>

			<!--- Verifica tipo de socios para controlar si se sincroniza con tabla de Clientes o con tabla de Proveedores--->
			<cfif trim(rsSocio.SNtiposocio) EQ "P" or trim(rsSocio.SNtiposocio) EQ "A">
				<!--- WS INSERT CLIENTE - LDCOM --->
					<cftry>
						<cfscript>
							xmlArgumentsPro = XmlNew();
							xmlArgumentsPro.xmlRoot = XmlElemNew(xmlArgumentsPro,"clientes");
							xmlArgumentsPro.clientes.XmlChildren[1] = XmlElemNew(xmlArgumentsPro,"cliente");
							/*Emp_Id*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[1] = XmlElemNew(xmlArgumentsPro,"Emp_Id");
							xmlArgumentsPro.clientes.cliente.Emp_Id.XmlText= "1";
							/*Cadena*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[2] = XmlElemNew(xmlArgumentsPro,"Cadena");
							xmlArgumentsPro.clientes.cliente.Cadena.XmlText= "#rsEmpresas.EQUcodigoOrigen#";
							/*Tipo_Id*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[3] = XmlElemNew(xmlArgumentsPro,"Tipo_Id");
							xmlArgumentsPro.clientes.cliente.Tipo_Id.XmlText= "2";/*Contado=1, Cr�dito=2*/
							/*Cliente_Nombre*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[4] = XmlElemNew(xmlArgumentsPro,"Cliente_Nombre");
							xmlArgumentsPro.clientes.cliente.Cliente_Nombre.XmlText= "#rsSocio.SNnombre#";
							/*Cliente_Nombre_Comercial*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[5] = XmlElemNew(xmlArgumentsPro,"Cliente_Nombre_Comercial");
							xmlArgumentsPro.clientes.cliente.Cliente_Nombre_Comercial.XmlText= "#rsSocio.SNnombre#";
							/*Cliente_Cedula*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[6] = XmlElemNew(xmlArgumentsPro,"Cliente_Cedula");
							xmlArgumentsPro.clientes.cliente.Cliente_Cedula.XmlText= "#rsSocio.SNidentificacion#";
							/*Cliente_Apdo*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[7] = XmlElemNew(xmlArgumentsPro,"Cliente_Apdo");
							xmlArgumentsPro.clientes.cliente.Cliente_Apdo.XmlText= "#rsSocio.codPostal#";
							/*Cliente_Direccion*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[8] = XmlElemNew(xmlArgumentsPro,"Cliente_Direccion");
							xmlArgumentsPro.clientes.cliente.Cliente_Direccion.XmlText= "#Trim(rsSocio.SNdireccion)#";
							/*Cliente_Email*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[9] = XmlElemNew(xmlArgumentsPro,"Cliente_Email");
							xmlArgumentsPro.clientes.cliente.Cliente_Email.XmlText= "#rsSocio.SNemail#";
							/*Cliente_Celular*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[10] = XmlElemNew(xmlArgumentsPro,"Cliente_Celular");
							xmlArgumentsPro.clientes.cliente.Cliente_Celular.XmlText= "#rsSocio.SNtelefono#";
							/*Cliente_Fax*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[11] = XmlElemNew(xmlArgumentsPro,"Cliente_Fax");
							xmlArgumentsPro.clientes.cliente.Cliente_Fax.XmlText= "#rsSocio.SNfax#";
							/*Cliente_Telefono*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[12] = XmlElemNew(xmlArgumentsPro,"Cliente_Telefono");
							xmlArgumentsPro.clientes.cliente.Cliente_Telefono.XmlText= "#rsSocio.SNtelefono#";
							/*Cliente_Credito_Limite*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[13] = XmlElemNew(xmlArgumentsPro,"Cliente_Credito_Limite");
							xmlArgumentsPro.clientes.cliente.Cliente_Credito_Limite.XmlText= "#rsSocio.SNmontoLimiteCC#";
							/*Cliente_Credito_Saldo*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[14] = XmlElemNew(xmlArgumentsPro,"Cliente_Credito_Saldo");
							xmlArgumentsPro.clientes.cliente.Cliente_Credito_Saldo.XmlText= "#rsSocio.SaldoSN#";
							/*Tipo_Documento*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[15] = XmlElemNew(xmlArgumentsPro,"Tipo_Documento");
							xmlArgumentsPro.clientes.cliente.Tipo_Documento.XmlText= "4";/*(Contado=1, Cr�dito=4)*/
							/*Cliente_CodigoExterno*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[16] = XmlElemNew(xmlArgumentsPro,"Cliente_CodigoExterno");
							xmlArgumentsPro.clientes.cliente.Cliente_CodigoExterno.XmlText= "#rsSocio.SNcodigoext#";
							/*Cliente_Estado*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[17] = XmlElemNew(xmlArgumentsPro,"Cliente_Estado");
							/*(Activo=A, Inactivo=I)*/
							if (#rsSocio.SNinactivo# is 0){
								xmlArgumentsPro.clientes.cliente.Cliente_Estado.XmlText= "A";
							} else {
								xmlArgumentsPro.clientes.cliente.Cliente_Estado.XmlText= "I";
							}
							/*Tipo_Socio*/
							xmlArgumentsPro.clientes.cliente.XmlChildren[18] = XmlElemNew(xmlArgumentsPro,"Tipo_Socio");
							xmlArgumentsPro.clientes.cliente.Tipo_Socio.XmlText= "#rsSocio.SNtiposocio#";/*(Cliente=C, Proveedor=P, Ambos=A)*/
						</cfscript>

						<!--- Se quitan saltos de linea --->
						<cfset stringArgumentsPro = #replace(ToString(ToString(xmlArgumentsPro)),"&##xd;","","all")#>

						<cfif isdefined("rsGetWsdlWS") AND rsGetWsdlWS.recordcount GT 0>
							<!--- LLAMADA AL WS DE LDCOM --->
							<cfinvoke
							   method="Cliente_Insert_SIF_XML"
							   returnvariable="result"
							   wsversion="1"
							   webservice="#rsGetWsdlWS.Pvalor#"
							   >
							    <cfinvokeargument name="pConexion" value="pConexion"/>
								<cfinvokeargument name="pDatos" value="#stringArgumentsPro#"/>
							</cfinvoke>


							<cfif findNoCase("Error", "#result#") GT 0>
								<cflog file="Sincronizacion_Clientes_WS"
								       application="no"
								       text="Proceso: Insertar Cliente: [#rsSocio.SNnombre#], [#result#], #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
							<cfelse>
								<cflog file="Sincronizacion_Clientes_WS"
									       application="no"
									       text=" Cliente/Proveedor en LD, [#result#], #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
							</cfif>
						</cfif>
					<cfcatch type="any">
						<cflog file="Sincronizacion_Clientes_WS"
							       application="no"
							       text="Proceso: Insertar Cliente: [#rsSocio.SNnombre#], [#cfcatch.message#], #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
					</cfcatch>
					</cftry>
			</cfif>

			<cfif trim(rsSocio.SNtiposocio) EQ "C" or trim(rsSocio.SNtiposocio) EQ "A">
				<cfset intfaz = rsSocio.intfazLD>
                <cfset saldoSN =  rsSocio.SaldoCliente>
				<cfset limite = rsSocio.SNmontoLimiteCC>
                <cfquery name="getSaldoCliente" datasource="#session.dsn#">
                	select
	   					coalesce(SUM(round(d.Dsaldo  * d.Dtcultrev * case when t.CCTtipo = 'D' then 1.00 else -1.00 end, 2)),0) as Saldo
		 			from Documentos d
		 			inner join CCTransacciones t on t.CCTcodigo = d.CCTcodigo and t.Ecodigo = d.Ecodigo
				    where d.Dsaldo <> 0.00
                    and d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.Ecodigo#">
                    and d.SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNcodigo#">
                </cfquery>

				<cfif trim(rsSocio.SNtiposocio) NEQ "A"> <!--- No se ejecuta cuando es tipo A para que se procese como Cliente --->
	                <cfif saldoSN NEQ getSaldoCliente.Saldo>
	                		<cfset intfaz=1>
	                        <cfset saldoSN=getSaldoCliente.Saldo>
	                </cfif>
				</cfif>

                <cfif intfaz NEQ 1 and rsSocio.SNmontoLimiteCC GTE 0> <!--- se agrega filtro para exportar solo los Socios Cleintes con limite de credito definido --->
					<!--- WS INSERT CLIENTE - LDCOM --->
					<cftry>
							<cfscript>
								xmlArguments = XmlNew();
								xmlArguments.xmlRoot = XmlElemNew(xmlArguments,"clientes");
								xmlArguments.clientes.XmlChildren[1] = XmlElemNew(xmlArguments,"cliente");
								/*Emp_Id*/
								xmlArguments.clientes.cliente.XmlChildren[1] = XmlElemNew(xmlArguments,"Emp_Id");
								xmlArguments.clientes.cliente.Emp_Id.XmlText= "1";
								/*Cadena*/
								xmlArguments.clientes.cliente.XmlChildren[2] = XmlElemNew(xmlArguments,"Cadena");
								xmlArguments.clientes.cliente.Cadena.XmlText= "#rsEmpresas.EQUcodigoOrigen#";
								/*Tipo_Id*/
								xmlArguments.clientes.cliente.XmlChildren[3] = XmlElemNew(xmlArguments,"Tipo_Id");
								xmlArguments.clientes.cliente.Tipo_Id.XmlText= "2";/*Contado=1, Cr�dito=2*/
								/*Cliente_Nombre*/
								xmlArguments.clientes.cliente.XmlChildren[4] = XmlElemNew(xmlArguments,"Cliente_Nombre");
								xmlArguments.clientes.cliente.Cliente_Nombre.XmlText= "#rsSocio.SNnombre#";
								/*Cliente_Nombre_Comercial*/
								xmlArguments.clientes.cliente.XmlChildren[5] = XmlElemNew(xmlArguments,"Cliente_Nombre_Comercial");
								xmlArguments.clientes.cliente.Cliente_Nombre_Comercial.XmlText= "#rsSocio.SNnombre#";
								/*Cliente_Cedula*/
								xmlArguments.clientes.cliente.XmlChildren[6] = XmlElemNew(xmlArguments,"Cliente_Cedula");
								xmlArguments.clientes.cliente.Cliente_Cedula.XmlText= "#rsSocio.SNidentificacion#";
								/*Cliente_Apdo*/
								xmlArguments.clientes.cliente.XmlChildren[7] = XmlElemNew(xmlArguments,"Cliente_Apdo");
								xmlArguments.clientes.cliente.Cliente_Apdo.XmlText= "#rsSocio.codPostal#";
								/*Cliente_Direccion*/
								xmlArguments.clientes.cliente.XmlChildren[8] = XmlElemNew(xmlArguments,"Cliente_Direccion");
								xmlArguments.clientes.cliente.Cliente_Direccion.XmlText= "#Trim(rsSocio.SNdireccion)#";
								/*Cliente_Email*/
								xmlArguments.clientes.cliente.XmlChildren[9] = XmlElemNew(xmlArguments,"Cliente_Email");
								xmlArguments.clientes.cliente.Cliente_Email.XmlText= "#rsSocio.SNemail#";
								/*Cliente_Celular*/
								xmlArguments.clientes.cliente.XmlChildren[10] = XmlElemNew(xmlArguments,"Cliente_Celular");
								xmlArguments.clientes.cliente.Cliente_Celular.XmlText= "#rsSocio.SNtelefono#";
								/*Cliente_Fax*/
								xmlArguments.clientes.cliente.XmlChildren[11] = XmlElemNew(xmlArguments,"Cliente_Fax");
								xmlArguments.clientes.cliente.Cliente_Fax.XmlText= "#rsSocio.SNfax#";
								/*Cliente_Telefono*/
								xmlArguments.clientes.cliente.XmlChildren[12] = XmlElemNew(xmlArguments,"Cliente_Telefono");
								xmlArguments.clientes.cliente.Cliente_Telefono.XmlText= "#rsSocio.SNtelefono#";
								/*Cliente_Credito_Limite*/
								xmlArguments.clientes.cliente.XmlChildren[13] = XmlElemNew(xmlArguments,"Cliente_Credito_Limite");
								xmlArguments.clientes.cliente.Cliente_Credito_Limite.XmlText= "#rsSocio.SNmontoLimiteCC#";
								/*Cliente_Credito_Saldo*/
								xmlArguments.clientes.cliente.XmlChildren[14] = XmlElemNew(xmlArguments,"Cliente_Credito_Saldo");
								xmlArguments.clientes.cliente.Cliente_Credito_Saldo.XmlText= "#saldoSN#";
								/*Tipo_Documento*/
								xmlArguments.clientes.cliente.XmlChildren[15] = XmlElemNew(xmlArguments,"Tipo_Documento");
								xmlArguments.clientes.cliente.Tipo_Documento.XmlText= "4";/*(Contado=1, Cr�dito=4)*/
								/*Cliente_CodigoExterno*/
								xmlArguments.clientes.cliente.XmlChildren[16] = XmlElemNew(xmlArguments,"Cliente_CodigoExterno");
								xmlArguments.clientes.cliente.Cliente_CodigoExterno.XmlText= "#rsSocio.SNcodigoext#";
								/*Cliente_Estado*/
								xmlArguments.clientes.cliente.XmlChildren[17] = XmlElemNew(xmlArguments,"Cliente_Estado");
								/*(Activo=A, Inactivo=I)*/
								if (#rsSocio.SNinactivo# is 0){
									xmlArguments.clientes.cliente.Cliente_Estado.XmlText= "A";
								} else {
									xmlArguments.clientes.cliente.Cliente_Estado.XmlText= "I";
								}
								/*Tipo_Socio*/
								xmlArguments.clientes.cliente.XmlChildren[18] = XmlElemNew(xmlArguments,"Tipo_Socio");
								xmlArguments.clientes.cliente.Tipo_Socio.XmlText= "#rsSocio.SNtiposocio#";/*(Cliente=C, Proveedor=P, Ambos=A)*/
							</cfscript>

							<!--- Se quitan saltos de linea --->
							<cfset stringArguments = #replace(ToString(ToString(xmlArguments)),"&##xd;","","all")#>

							<cfif isdefined("rsGetWsdlWS") AND rsGetWsdlWS.recordcount GT 0>
								<!--- LLAMADA AL WS DE LDCOM --->
								<cfinvoke
								   method="Cliente_Insert_SIF_XML"
								   returnvariable="result"
								   wsversion="1"
								   webservice="#rsGetWsdlWS.Pvalor#"
								   >
								    <cfinvokeargument name="pConexion" value="pConexion"/>
									<cfinvokeargument name="pDatos" value="#stringArguments#"/>
								</cfinvoke>

								<cfif findNoCase("Error", "#result#") GT 0>
									<cflog file="Sincronizacion_Clientes_WS"
									       application="no"
									       text="Proceso: Insertar Cliente: [#rsSocio.SNnombre#], [#result#], #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
								<cfelse>
									<cflog file="Sincronizacion_Clientes_WS"
										       application="no"
										       text="Cliente/Proveedor en LD, [#result#], #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
								</cfif>
							</cfif>
					<cfcatch type="any">
						<cflog file="Sincronizacion_Clientes_WS"
							       application="no"
							       text="Proceso: Insertar Cliente: [#rsSocio.SNnombre#], [#cfcatch.message#], #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
					</cfcatch>
					</cftry>
                    <cfquery name="updSinc" datasource="#session.dsn#">
                    	update SNegocios
                        set intfazLD=1,SaldoCliente=#saldoSN#
                        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.Ecodigo#">
                        and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNcodigo#">
                    </cfquery>
                 </cfif>
			</cfif>
		</cfloop> <!---Cierra loop socio--->
		</cfif>
	</cfloop> <!---Cierra loop empresa--->
	</cfif>
	<cflog file="Sincronizacion_Clientes_WS" application="no" text="Termina proceso sincronizacion de clientes, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
</cffunction>
</cfcomponent>