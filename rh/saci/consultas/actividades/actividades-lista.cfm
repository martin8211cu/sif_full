<cfset filtro= "">
<cfset navegacion = "">
<cfset check1 = "<img src=''/cfmx/saci/images/w-check.gif'' border=''0'' title=''Automatica''>">
<cfif isdefined('form.pagina') and form.pagina NEQ ''>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "pagina=" & form.pagina>	
</cfif>
<cfif isdefined('form.tipo') and form.tipo NEQ ''>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "tipo=" & form.tipo>	
</cfif>
<cfif isdefined('form.Consultar')>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "Consultar=" & form.Consultar>	
</cfif>
<cfif isdefined("form.fdesde")and len(trim(form.fdesde))>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "fdesde=" & form.fdesde>	
	<cfif isdefined('form.tipo')>
		<cfif form.tipo EQ 1>		<!--- Cuenta/Login --->
			<cfset filtro = filtro&" and BLfecha >= #LSParseDateTime(form.fdesde)#">
		<cfelseif form.tipo EQ 2>	<!--- Prepagos --->
			<cfset filtro = filtro&" and BPfecha >= #LSParseDateTime(form.fdesde)#">		
		<cfelseif form.tipo EQ 3>	<!--- Medios --->
			<cfset filtro = filtro&" and BTfecha >= #LSParseDateTime(form.fdesde)#">		
		</cfif>
	</cfif>
</cfif>
<cfif isdefined("form.fhasta")and len(trim(form.fhasta))>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "fhasta=" & form.fhasta>
	<cfif isdefined('form.tipo')>
		<cfif form.tipo EQ 1>		<!--- Cuenta/Login --->
			<cfset filtro = filtro&" and BLfecha <= #LSParseDateTime(form.fhasta)#">
		<cfelseif form.tipo EQ 2>	<!--- Prepagos --->
			<cfset filtro = filtro&" and BPfecha <= #LSParseDateTime(form.fhasta)#">
		<cfelseif form.tipo EQ 3>	<!--- Medios --->
			<cfset filtro = filtro&" and BTfecha <= #LSParseDateTime(form.fhasta)#">
		</cfif>
	</cfif>	
</cfif>
<!--- Para Cuenta/Login --->
<cfif isdefined('form.tipo') and form.tipo EQ 1 and isdefined("form.F_LGlogin")and len(trim(form.F_LGlogin))>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "F_LGlogin=" & form.F_LGlogin>	
	<cfset filtro = filtro&" and upper(ltrim(rtrim(LGlogin))) like '%#ucase(trim(form.F_LGlogin))#%'">
</cfif>

<!--- Para Prepago --->
<cfif isdefined('form.tipo') and form.tipo EQ 2 and isdefined("form.TJlogin")and len(trim(form.TJlogin))>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "TJlogin=" & form.TJlogin>	
	<cfset filtro = filtro&" and upper(ltrim(rtrim(TJlogin))) like '%#ucase(trim(form.TJlogin))#%'">
</cfif>

<!--- Para Medios --->
<cfif isdefined('form.tipo') and form.tipo EQ 3 and isdefined("form.MDref")and len(trim(form.MDref))>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "MDref=" & form.MDref>	
	<cfset filtro = filtro&" and upper(ltrim(rtrim(MDref))) like '%#ucase(trim(form.MDref))#%'">
</cfif>

<cfif isdefined("form.fUsuario")and len(trim(form.fUsuario))>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "fUsuario=" & form.fUsuario>	
	<cfif isdefined('form.tipo')>
		<cfif form.tipo EQ 1>		<!--- Cuenta/Login --->
			<cfset filtro = filtro&" and upper(ltrim(rtrim(BLusuario))) like '%#ucase(trim(form.fUsuario))#%'">	
		<cfelseif form.tipo EQ 2>	<!--- Prepagos --->
			<cfset filtro = filtro&" and upper(ltrim(rtrim(BPusuario))) like '%#ucase(trim(form.fUsuario))#%'">	
		<cfelseif form.tipo EQ 3>	<!--- Medios --->
			<cfset filtro = filtro&" and upper(ltrim(rtrim(BTusuario))) like '%#ucase(trim(form.fUsuario))#%'">
		</cfif>
	</cfif>	
</cfif>

<cfif isdefined("form.fChk_Automatica")>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "fChk_Automatica=" & form.fChk_Automatica>	
	<cfif isdefined('form.tipo')>
		<cfif form.tipo EQ 1>		<!--- Cuenta/Login --->
			<cfset filtro = filtro&" and BLautomatica = 1">			
		<cfelseif form.tipo EQ 2>	<!--- Prepagos --->
			<cfset filtro = filtro&" and BPautomatica = 1">		
		<cfelseif form.tipo EQ 3>	<!--- Medios --->
			<cfset filtro = filtro&" and BTautomatica = 1">
		</cfif>
	</cfif>
<cfelse>
	<cfif isdefined('form.tipo')>
		<cfif form.tipo EQ 1>		<!--- Cuenta/Login --->
			<cfset filtro = filtro&" and BLautomatica = 0">				
		<cfelseif form.tipo EQ 2>	<!--- Prepagos --->
			<cfset filtro = filtro&" and BPautomatica = 0">		
		<cfelseif form.tipo EQ 3>	<!--- Medios --->
			<cfset filtro = filtro&" and BTautomatica = 0">
		</cfif>
	</cfif>		
</cfif>

<cfif isdefined('form.tipo')>
	<cfif form.tipo EQ 1>	<!--- Cuenta/Login --->
		<cfset tablas = "ISBbitacoraLogin">
		<cfset columnas = "BLid
						, LGlogin
						, BLfecha
						, BLfecha as BLhora
						, BLobs
						, BLusuario
						, case BLautomatica
							when 0 then ' '
							when 1 then '#check1#'
						end BLautomatica">	
		<cfset desplegar = "BLfecha, BLhora, BLobs, BLusuario, LGlogin, BLautomatica">
		<cfset etiquetas = "Fecha, Hora, Observaciones, Usuario, Login, Automática">	
		<cfset formatos = "D,H,S,S,S,U">		
		<cfset align = "left,left,left,left,left,center">
		<cfset filtroFinal = "#filtro# order by BLfecha desc">			
		<cfset Keys = "BLid">
	<cfelseif form.tipo EQ 2>	<!--- Prepagos --->
		<cfset tablas = "ISBbitacoraPrepago">
		<cfset columnas = "
						BPid
						, TJlogin
						, BPfecha
						, BPobs
						, BPusuario
						, case BPautomatica
							when 0 then ' '
							when 1 then '#check1#'
						end BPautomatica">	
		<cfset desplegar = "BPfecha, BPobs, BPusuario, TJlogin, BPautomatica">
		<cfset etiquetas = "Fecha, Observaciones, Usuario, Login, Automática">
		<cfset formatos = "D,S,S,S,U">
		<cfset align = "left,left,left,left,center">
		<cfset filtroFinal = "#filtro# order by BPfecha desc">		
		<cfset Keys = "BPid">
	<cfelseif form.tipo EQ 3>	<!--- Medios --->	
		<cfset tablas = "ISBbitacoraMedio">
		<cfset columnas = " BTid
							, MDref
							, BTfecha
							, BTobs
							, BTusuario
							, case BTautomatica
								when 0 then ' '
								when 1 then '#check1#'
							end BTautomatica">	
		<cfset desplegar = "BTfecha, BTobs, BTusuario, MDref, BTautomatica">
		<cfset etiquetas = "Fecha, Observaciones, Usuario, MDref, Automática">
		<cfset formatos = "D,S,S,S,U">
		<cfset align = "left,left,left,left,center">
		<cfset filtroFinal = "#filtro# order by BTfecha desc">		
		<cfset Keys = "BTid">		
	</cfif>
	
	<cfinvoke 
		component="sif.Componentes.pListas"
		method="pLista"
		returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="#tablas#"/>
		<cfinvokeargument name="columnas" value="#columnas#"/> 
		<cfinvokeargument name="desplegar" value="#desplegar#"/> 
		<cfinvokeargument name="etiquetas" value="#etiquetas#"/>
		<cfinvokeargument name="formatos" value="#formatos#"/>
		<cfinvokeargument name="filtro" value="1=1 #filtroFinal#"/> 
		<cfinvokeargument name="align" value="#align#"/>
		<cfinvokeargument name="ajustar" value="N"/> 
		<cfinvokeargument name="checkboxes" value="N"/> 
		<cfinvokeargument name="irA" value="actividades.cfm"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="keys" value="#Keys#"/> 
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="funcion" value="Selecciona"/>
		<cfinvokeargument name="fparams" value="#Keys#"/>		
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="maxRows" value="20"/>
		<cfinvokeargument name="MaxRowsQuery" value="200"/>		
	</cfinvoke>
	
	<cfoutput>	
		<script language="javascript" type="text/javascript">
			var popUpWin=0; 
			function popUpWindow(URLStr, left, top, width, height){
			  if(popUpWin){
				if(!popUpWin.closed) popUpWin.close();
			  }
			  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=yes,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
			function Selecciona(param){
				popUpWindow("/cfmx/saci/consultas/actividades/detalleActiv.cfm?tipo=#form.tipo#&llave=" + param,200,100,700,300);
				return false;
			}
		</script>	
	</cfoutput>
</cfif>

