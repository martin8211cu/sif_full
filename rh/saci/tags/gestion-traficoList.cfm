<cfparam 	name="Attributes.form" 				type="string"	default="lista">				<!--- nombre del formulario para la lista --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#session.DSN#">		<!--- cache de conexión --->
<cfparam 	name="Attributes.tipoFiltro"	 	type="integer"	default="1">					<!--- tipo 1- ISBeventoLogin, ISBeventoPrepago, ISBeventoMedio, 2- Login --->
<cfparam 	name="Attributes.idCliente"	 	 	type="integer" default="-1">					<!--- Pquien del cliente --->
<cfparam 	name="Attributes.incluyeTemplate" 	type="string" default="">						<!--- parametros extra para la navegacion de la lista y para consultar --->

<cfparam name="url.tipo" default="1">
<cfset existeCliente = (isdefined("Attributes.idCliente") and Len(Trim(Attributes.idCliente)) and Attributes.idCliente NEQ -1)>
<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
<cfif Attributes.tipoFiltro EQ 2 and not existeCliente>
	<cfthrow message="Error: para utilizar el tipo de filtro 2 se requiere enviar el atributo idCliente">
</cfif>

<cfoutput>
	<form method="get" name="formFiltroTrafico" action="#CurrentPage#" style="margin:0" onSubmit="return validaFiltro(this);">
		<cfif isdefined("Attributes.incluyeTemplate") and Len(Trim(Attributes.incluyeTemplate))>
			<cfinclude template="#Attributes.incluyeTemplate#">
		</cfif>
		
		<table  width="100%"cellpadding="2" cellspacing="0" border="0">		
			<tr>
				<td class="tituloAlterno" align="left">
					<cfif Attributes.tipoFiltro EQ 1>
						<table  id="table" cellpadding="2" cellspacing="0" border="0">
							<tr>
								<td align="right"><label><cf_traducir key="consultar">Consultar</cf_traducir> <cf_traducir key="por">por</cf_traducir></label></td>
								<td width="150">
									<select name="tipo"  id="tipo" tabindex="1" onchange="javascript: mostrarTipo();">
										<option value="1" <cfif isdefined("url.tipo") and url.tipo EQ 1>selected</cfif>>Cuenta-Login<!---<cf_traducir key="cuenta">Cuenta</cf_traducir>-<cf_traducir key="login">Login</cf_traducir>---></option>
										<option value="2" <cfif isdefined("url.tipo") and url.tipo EQ 2>selected</cfif>>Prepago<!---<cf_traducir key="prepago">Prepago</cf_traducir>---></option>
										<option value="3" <cfif isdefined("url.tipo") and url.tipo EQ 3>selected</cfif>>Medios<!---<cf_traducir key="medio">Medios</cf_traducir>---></option>
									</select>
								</td>
								<td id="login1" align="right" style="<cfif url.tipo neq 1>display:none;</cfif>"><label><cf_traducir key="cuenta">Cuenta</cf_traducir></label></td>
								<td id="login2" style="<cfif url.tipo neq 1>display:none;</cfif>">							
									<cfset valCuecue = "">
										<cfif isdefined('url.F_CUECUE') and len(trim(url.F_CUECUE))>
											<cfset valCuecue = url.F_CUECUE>
										</cfif>								
									<cf_campoNumerico name="F_CUECUE" decimales="-1" size="18" maxlength="15" value="#valCuecue#" tabindex="1" nullable="yes">
									<label><cf_traducir key="login">Login</cf_traducir></label>
									<input type="text" name="F_LGlogin" value="<cfif isdefined("url.F_LGlogin") and len(trim(url.F_LGlogin))>#url.F_LGlogin#</cfif>">
								</td>
								<td id="prepago1" align="right" style="<cfif url.tipo neq 2>display:none;</cfif>"><label><cf_traducir key="prepago">Prepago</cf_traducir></label></td>
								<td id="prepago2"align="left" style="<cfif url.tipo neq 2>display:none;</cfif>">		
										<input name="TJlogin" 
											id="TJlogin"
											type="text" 
											maxlength="30" size="30"
											value="<cfif isdefined("url.TJlogin")and len(trim(url.TJlogin))>#url.TJlogin#</cfif>" >
								</td>
								<td id="medio1" align="right" style="<cfif url.tipo neq 3>display:none;</cfif>"><label><cf_traducir key="medio">Medio</cf_traducir></label></td>
								<td id="medio2" style="<cfif url.tipo neq 3>display:none;</cfif>">
									<input name="MDref" 
										id="MDref"
										type="text" 
										maxlength="30" size="30"
										value="<cfif isdefined("url.MDref")and len(trim(url.MDref))>#url.MDref#</cfif>">
								</td>
							</tr>
						</table>
					<cfelse>
						<cfif isdefined("url.F_LGnumero") and len(trim(url.F_LGnumero))>
							<cfset arr = ListToArray(url.F_LGnumero)>	
						</cfif>
						<cfquery name="rsLogines" datasource="#session.DSN#">
							select distinct a.CTid,a.CUECUE,c.LGnumero,c.LGlogin,a.CTtipoUso,c.Habilitado as LoginHabilitado
							from ISBcuenta a
								inner join ISBproducto b
									on b.CTid = a.CTid
								inner join ISBlogin c
									on c.Contratoid = b.Contratoid
								inner join ISBserviciosLogin d
									on d.LGnumero = c.LGnumero
									and d.TScodigo = 'ACCS'
							where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idCliente#">
							and a.Habilitado=1
						</cfquery>
						
						<table  width="100%"cellpadding="2" cellspacing="0" border="0">
							<tr>
								<td><label><cf_traducir key="login">Login</cf_traducir></label>
									<cfset corte="">
									<select name="F_LGnumero" id="F_LGnumero" tabindex="1">
										<option value="">---Todas---</option>
										<cfloop query="rsLogines">
											<cfif corte NEQ rsLogines.CTid>
												<cfset corte = rsLogines.CTid>
												<option  value="#corte#" <cfif isdefined("arr") and ArrayLen(arr) EQ 1 and arr[1] EQ corte> selected</cfif>>
													<cfif rsLogines.CUECUE GT 0>
														#rsLogines.CUECUE#
													<cfelseif rsLogines.CTtipoUso EQ 'U'>
														&lt;Por Asignar&gt;
													<cfelseif rsLogines.CTtipoUso EQ 'A'>
														(Acceso) &lt;Por Asignar&gt;
													<cfelseif rsLogines.CTtipoUso EQ 'F'>
														(Facturaci&oacute;n) &lt;Por Asignar&gt;
													</cfif>
												</option>
											</cfif>
											<option value="#rsLogines.LGnumero#,#corte#"
												<cfif isdefined("arr") and ArrayLen(arr) EQ 2 and arr[1] EQ rsLogines.LGnumero and arr[2] EQ corte> selected</cfif>>
												&nbsp;&nbsp;&nbsp;&nbsp;-#rsLogines.LGlogin#
												<cfif rsLogines.LoginHabilitado neq 1>(inactivo)</cfif>
											</option>
										</cfloop>
									</select>
							</td></tr>
						</table>
					</cfif>
				</td>
			</tr>
			<tr>
				<td class="tituloAlterno">				
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td><label><cf_traducir key="desde">Desde</cf_traducir></label></td>
						<td><label><cf_traducir key="hasta">Hasta</cf_traducir></label></td>
						<td><label><cf_traducir key="tel">Tel&eacute;fono</cf_traducir></label></td>
						<td><label><cf_traducir key="dir">Direcci&oacute;n IP</cf_traducir></label></td>
						<td rowspan="2" align="center" valign="middle">
							<cf_botones names="Consultar" values="Consultar" tabindex="1">
						</td>
					  </tr>
					  <tr>
						<td>
							<cfif isdefined("url.fdesde") and len(trim(url.fdesde))>
								<cfset fdesde=url.fdesde>
							<cfelse>
								<cfset fdesde=LSDateFormat(now(),'dd/mm/yyyy')>
							</cfif>					
							<cf_sifcalendario form="formFiltroTrafico" name="fdesde" value="#fdesde#">
						</td>
						<td>
							<cfif isdefined("url.fhasta") and len(trim(url.fhasta))>
								<cfset fhasta=url.fhasta>
							<cfelse>
								<cfset fhasta=LSDateFormat(now(),'dd/mm/yyyy')>
							</cfif>
							<cf_sifcalendario form="formFiltroTrafico" name="fhasta" value="#fhasta#">
						</td>
						<td><input name="fEVtelefono" size="15" type="text" value="<cfif isdefined("url.fEVtelefono")>#url.fEVtelefono#</cfif>"/></td>
						<td><input name="fipaddr" size="15" type="text" value="<cfif isdefined("url.fipaddr")>#url.fipaddr#</cfif>"/></td>
					  </tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</cfoutput>	
<script language="javascript" type="text/javascript">
<cfif Attributes.tipoFiltro EQ 1>		<!--- ISBeventoLogin, ISBeventoPrepago, ISBeventoMedio --->
	function mostrarTipo(){
		var tipo = document.formFiltroTrafico.tipo.value;
		if (tipo==0){
			<!---document.getElementById('label1').style.display='';--->
			document.getElementById('login1').style.display='none';
			document.getElementById('login2').style.display='none';
			document.getElementById('prepago1').style.display='none';
			document.getElementById('prepago2').style.display='none';
			document.getElementById('medio1').style.display='none';
			document.getElementById('medio2').style.display='none';
		}
		if(tipo==1){
			<!---document.getElementById('label1').style.display='none';--->
			document.getElementById('login1').style.display='';
			document.getElementById('login2').style.display='';
			document.getElementById('prepago1').style.display='none';
			document.getElementById('prepago2').style.display='none';
			document.getElementById('medio1').style.display='none';
			document.getElementById('medio2').style.display='none';
		}
		if(tipo==2){
			<!---document.getElementById('label1').style.display='none';--->
			document.getElementById('login1').style.display='none';
			document.getElementById('login2').style.display='none';
			document.getElementById('prepago1').style.display='';
			document.getElementById('prepago2').style.display='';
			document.getElementById('medio1').style.display='none';
			document.getElementById('medio2').style.display='none';
		}
		if(tipo==3){
			<!---document.getElementById('label1').style.display='none';--->
			document.getElementById('login1').style.display='none';
			document.getElementById('login2').style.display='none';
			document.getElementById('prepago1').style.display='none';
			document.getElementById('prepago2').style.display='none';
			document.getElementById('medio1').style.display='';
			document.getElementById('medio2').style.display='';
		}
	}
	function validaFiltro(f){
		if(f.tipo.value == 2 && f.TJlogin.value != ''){	//Por Prepago
			if(f.TJid.value == ''){
				alert('Error, la tarjeta de prepago esta vacia.');
				return false;
			}
		}
		
		return true;
	}
	
	mostrarTipo();
<cfelse>
	function validaFiltro(f){
		return true;
	}
</cfif>
</script>	

<cfif isdefined('url.Consultar')>

	<cfset sem_verde = "'ACTIVO'">
	<cfset sem_rojo = "'INACTIVO'">

	<!---Genera el filtro para la lista segun los parametros--->
	<cfset filtro = "">	
	<cfset navegacion = "">	
	<cfset tablas="">
	<cfset columnas="">
	<cfset etiquetas="">

	<!---Filtro por Fechas--->
	<cfif isdefined("url.fdesde")and len(trim(url.fdesde))>
		<cfset filtro = filtro & " and e.EVinicio >= #LSParseDateTime(url.fdesde)#">
		<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "fdesde=" & url.fdesde>	
	</cfif>
	<cfif isdefined("url.fhasta")and len(trim(url.fhasta))>
		<cfset filtro = filtro & " and e.EVinicio <= #LSParseDateTime(url.fhasta)#">
		<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "fhasta=" & url.fhasta>	
	</cfif>
	<!---Filtro por Telefono --->
	<cfif isdefined("url.fEVtelefono")and len(trim(url.fEVtelefono))>
		<cfset filtro = filtro & " and upper(ltrim(rtrim(e.EVtelefono))) like '%#ucase(trim(url.fEVtelefono))#%'">
		<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "fEVtelefono=" & url.fEVtelefono>	
	</cfif>		
	<!--- Filtro por Direccion IP --->
	<cfif isdefined("url.fipaddr")and len(trim(url.fipaddr))>
		<cfset filtro = filtro & " and ltrim(rtrim(e.ipaddr)) like '%#trim(url.fipaddr)#%'">
		<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "fipaddr=" & url.fipaddr>			
	</cfif>

	<cfif Attributes.tipoFiltro EQ 1>		<!--- ISBeventoLogin, ISBeventoPrepago, ISBeventoMedio --->
		<!--- Tipo de consulta --->
		<cfif isdefined("url.tipo") and len(trim(url.tipo))>
			<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "tipo=" & url.tipo>	
		</cfif>	
		<cfif url.tipo EQ 1>	<!--- Cuenta/login --->
			<cfset filtro = filtro & " and a.Habilitado=1">
			<!---CUECUE - cuenta --->
			<cfif isdefined("url.F_CUECUE")and len(trim(url.F_CUECUE))>
				<cfset filtro = filtro & " and a.CUECUE = #url.F_CUECUE#">
			</cfif>		

			<!--- Filtro por Nombre del login--->
			<cfif isdefined("url.F_LGlogin") and len(trim(url.F_LGlogin))>
				<cfset filtro = filtro & " and upper(c.LGlogin) like '%#ucase(trim(url.F_LGlogin))#%'">
			</cfif>

			<cfset tablas="ISBcuenta a
						inner join ISBproducto b
							on b.CTid = a.CTid
						inner join ISBlogin c
							on c.Contratoid = b.Contratoid
						inner join ISBeventoLogin e
							on e.LGnumero = c.LGnumero
						inner join ISBserviciosLogin d
							on d.LGnumero = c.LGnumero
							and d.TScodigo = 'ACCS'">
			<cfset columnas=", a.CTid
							,'(' || (case a.CUECUE
								when 0 then '&lt;Por Asignar&gt;'
								else convert(varchar,a.CUECUE) 
							end || ') ' || c.LGlogin) as login
							,c.LGnumero, case when c.Habilitado = 1 then #sem_verde# else #sem_rojo# end as estado">
			<cfset etiquetas="(cuenta) Login,Estado">			
		<cfelseif url.tipo EQ 2>	<!---Prepagos ISBeventoPrepago --->
			<!---Prepago--->
			<cfif isdefined("url.TJlogin")and len(trim(url.TJlogin))>
				<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "TJlogin=" & url.TJlogin>	
				<cfset filtro = filtro & " and upper(b.TJlogin) like '%#ucase(trim(url.TJlogin))#%'">
			</cfif>			

			<cfset tablas="ISBeventoPrepago e
							inner join ISBprepago b
								on b.TJid=e.TJid">
			<cfset columnas=", b.TJlogin as login, case when b.TJestado = '1' then #sem_verde# else #sem_rojo# end as estado">
			<cfset etiquetas="Tarjeta Prepago,Estado">			
		<cfelseif url.tipo EQ 3>	<!---Medios ISBeventoMedio --->
			<!---Medios--->
			<cfif isdefined("url.MDref")and len(trim(url.MDref))>
				<cfset filtro = filtro & " and upper(e.MDref) like '%#ucase(trim(url.MDref))#%'">				
			</cfif>		
			<cfset tablas="ISBeventoMedio e
							inner join ISBmedio b
								on b.MDref=e.MDref
							inner join ISBmedioCia c
								on c.EMid=b.EMid
								and c.Ecodigo=#session.Ecodigo#">
			<cfset columnas=", e.MDref as login, case when b.Habilitado = 1 then #sem_verde# else #sem_rojo# end as estado">
			<cfset etiquetas="Medio,Estado">
		</cfif>
	<!--- ------------------------------- Login --------------------------------->
	<cfelseif Attributes.tipoFiltro EQ 2>	
		<cfif isdefined("url.F_LGnumero")and len(trim(url.F_LGnumero))>
			<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "F_LGnumero=" & url.F_LGnumero>			
			<!---Esta parte es especificamente para definir que valor viene en el combo si un id de login o un id de cuenta esto por que el combo tiene dos niveles: cuente y logines de la cuenta--->
			<cfif listLen(url.F_LGnumero,',') EQ 2>
				<cfset arr = ListToArray(url.F_LGnumero)>
				<cfset cuenta = arr[2]>
				<cfset url.F_LGnumero = arr[1]>
			<cfelseif listLen(url.F_LGnumero,',') EQ 1>
				<cfset cuenta = url.F_LGnumero>
				<cfset url.F_LGnumero="">			
			<cfelse>
				<cfset cuenta = "">
				<cfset url.F_LGnumero="">			
			</cfif>		
		</cfif>	

		<cfset filtro = filtro & " and a.Pquien = #Attributes.idCliente#">
		<!---Cuenta--->
		<cfif isdefined("cuenta")and len(trim(cuenta))> 
			<cfset filtro = filtro & " and a.CTid = #cuenta#">
		</cfif>		
		<cfif isdefined("url.F_LGnumero")and len(trim(url.F_LGnumero))>
			<cfset filtro = filtro & " and c.LGnumero = #url.F_LGnumero#">
		</cfif>


		<cfset tablas="ISBcuenta a
					inner join ISBproducto b
						on b.CTid = a.CTid
					inner join ISBlogin c
						on c.Contratoid = b.Contratoid
					inner join ISBeventoLogin e
						on e.LGnumero = c.LGnumero
					inner join ISBserviciosLogin d
						on d.LGnumero = c.LGnumero
						and d.TScodigo = 'ACCS'">
		<cfset columnas=", a.CTid
						,'(' || (case a.CUECUE
							when 0 then '&lt;Por Asignar&gt;'
							else convert(varchar,a.CUECUE) 
						end || ') ' || c.LGlogin) as login
						,c.LGnumero, case when c.Habilitado = 1 and a.Habilitado = 1 then #sem_verde# else #sem_rojo# end as estado">
		<cfset etiquetas="(cuenta) Login,Estado">			
	</cfif>

	<cfinvoke  
		component="sif.Componentes.pListas" 
		method="pLista">
		<cfinvokeargument name="tabla" value="#tablas#"/>
		<cfinvokeargument name="columnas" value="
											e.EVinicio
											,convert(varchar, floor(e.EVduracion / 3600)) || ':' || 
											 right('0' || convert(varchar, floor((e.EVduracion-(3600*floor(e.EVduracion / 3600))) / 60)), 2) || ':' || 
											 right('0' || convert(varchar, e.EVduracion-(3600*floor(e.EVduracion / 3600))-(60*floor((e.EVduracion-(3600*floor(e.EVduracion / 3600))) / 60))), 2) as EVduracion
											,e.EVtelefono
											,e.ipaddr
											#columnas#
											"/>
		<cfinvokeargument name="desplegar" value="login,estado,EVinicio,EVduracion,EVtelefono,ipaddr"/>
		<cfinvokeargument name="etiquetas" value="#etiquetas#,Fecha,Duraci&oacute;n,Tel&eacute;fono,Direcci&oacute;n IP"/>
		<cfinvokeargument name="filtro" value="1=1
											#filtro#"/>
		<cfinvokeargument name="formName" value="#Attributes.form#"/>
		<cfinvokeargument name="align" value="left,left,left,left,left,left"/>
		<cfinvokeargument name="formatos" value="S,S,D,S,S,S"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="maxrows" value="20"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="debug" value="N"/>		
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="MaxRowsQuery" value="250"/>
		<cfinvokeargument name="EmptyListMsg" value="----No hay datos disponibles----"/>
	</cfinvoke>
</cfif>
