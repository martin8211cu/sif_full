<cfif isdefined("url.PERIODO")>

	<cfset VPer = url.PERIODO>

<cfelse>

	<cfset VPer = Year(Now())>

</cfif>





<cfif VPer GTE 2006>

	<!--- APUNTA LAS CONEXIONES DE BASES DE DATOS A V6 --->

	<!--- <cfset session.dsn      		= "FONDOSWEB6"> --->

	<!--- <cfset session.Conta.dsn 		= "FONDOSWEB6"> --->

<cfelse>

	<cfset session.dsn      		= "ContaWeb">

	<!--- <cfset session.Conta.dsn 		= "ContaWeb"> --->

</cfif>


<!---<cfset session.dsn = "minisif"> --->


	
	<cfif VPer lt 2006>
	
		<!---
		NO SE USA PORQUE YA NO SE VALIDA DESDE V5 (advv - 22/08/2007)
		
		<cfquery name="rs" datasource="#session.Conta.dsn#">
	
				 set nocount on 
	
				 exec  ICEWEB..cg_ValidaCuenta
	
				 @CGE5COD  	= '#trim(url.CGE5COD)#' ,
	
				 @CGM1IM 	= '#trim(url.CGM1IM)#' ,	
	
				 @CGM1CD 	= '#trim(url.CGM1CD)#' 
	
				 set nocount off 	
	
		</cfquery>
		
		--->
	
	
	
	<cfelse>
		
		
		<!---
		SE CAMBIA LA VALIDACION DE LAS CUENTAS PARA QUE VAYA DIRECTO SOBRE V6 Y NO USE INTERFAZ (advv - 22/08/2007)
		
		<cfquery name="rs" datasource="#session.Conta.dsn#">
	
			set nocount on 
	
		
	
			declare 
	
				@CFcuenta int, 
	
				@msg_sal varchar(250)
	
			
	
			exec sif_interfaces..cg_CreaCuenta
	
						@Mayor 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1IM)#">, 
	
						@Detalle 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1CD)#">, 
	
						@Oficodigo    	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGE5COD)#">,
						<cfif Year(Now()) lt VPer>
							<cfset FechaCta ="VPer" & "0101">
							@Fecha	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#FechaCta#">
						</cfif>
						@CFcuenta		= @CFcuenta output,
	
						@MSG_sal		= @msg_sal output,
	
						@GenError		= 'N'
	
			
	
			if @msg_sal != 'OK' 
	
			begin
	
				select @msg_sal as resultado									 
	
			end
	
			else
	
			begin
	
				select 'La cuenta es correcta y puede ser utilizada.'	as resultado		
	
			end
	
			
	
			set nocount off
	
		</cfquery>
		--->
	
		<!--- VALIDACION MEDIANTE EL COMPONENTE DE VALIDACION DE CUENTAS --->
		
		<cfquery datasource="#session.dsn#" name="rsOficina">
		Select Ocodigo
		from Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and Oficodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGE5COD)#">
		</cfquery>
	
		<cfset LvarCmayor = trim(url.CGM1IM)> 
		<cfset LvarCFdetalle = trim(url.CGM1CD)>	
		<cfset LvarOficina = rsOficina.Ocodigo>
		<cfset LvarFecha = trim(url.FechaCta)>
		<cfset LvarMascara = trim(url.MASCARA)>
		
		<!--- Le pone guiones a la cuenta detalle --->
		<cfset MascaraInicial = mid(LvarMascara,6,len(LvarMascara))>
		<cfset Ctadetalle = "">
		<cfloop condition="find('-',MascaraInicial,1) gt 0">
			<cfset guion_pos = find("-",MascaraInicial,1)>

			<cfif Ctadetalle eq "">
				<cfset Ctadetalle = mid(trim(LvarCFdetalle),1,guion_pos-1)>
			<cfelse>
				<cfset Ctadetalle = Ctadetalle & "-" & mid(trim(LvarCFdetalle),1,guion_pos-1)>			
			</cfif>
			<cfset LvarCFdetalle = mid(trim(LvarCFdetalle),guion_pos,len(trim(LvarCFdetalle)))>			

			<cfset MascaraInicial = mid(MascaraInicial,guion_pos+1,len(MascaraInicial))>
		</cfloop>
		<cfset Ctadetalle = Ctadetalle & "-" & trim(LvarCFdetalle)>


		<cfinvoke 
		 component="sif.Componentes.PC_GeneraCuentaFinanciera"
		 method="fnGeneraCuentaFinanciera"
		 returnvariable="Lvar_MsgError">
			<cfinvokeargument name="Lprm_Cmayor"		value="#trim(LvarCmayor)#"/>
			<cfinvokeargument name="Lprm_Cdetalle"		value="#trim(Ctadetalle)#"/>
			<cfinvokeargument name="Lprm_Ecodigo"		value="#session.Ecodigo#"/>
			<cfinvokeargument name="Lprm_Ocodigo"		value="#LvarOficina#"/>
			<cfinvokeargument name="Lprm_SoloVerificar"	value="true"/>
			<cfif LvarFecha NEQ "">
				<cfinvokeargument name="Lprm_Fecha"		value="#LSParseDateTime(LvarFecha)#"/>
			</cfif>		
		</cfinvoke>
			
		<cfif 	isdefined('Lvar_MsgError') 
				AND (Lvar_MsgError NEQ "" 
				AND Lvar_MsgError NEQ "OLD" 
				AND Lvar_MsgError NEQ "NEW")>
				
			<cfset LvarResultado = fnJSStringFormat("ERROR: " & Lvar_MsgError)>
			
		<cfelseif isdefined('Lvar_MsgError') 
				AND (Lvar_MsgError EQ "NEW" 
				OR Lvar_MsgError EQ "OLD")>
		
			<cfset LvarResultado = fnJSStringFormat("La cuenta es correcta y puede ser utilizada.")>
		
		</cfif>
	
	</cfif>



<cfif isdefined("LvarResultado")  and LvarResultado neq "">

	<table width="100%" border="0">

		<tr>

			<td align="center" bgcolor="#FFFF00"><strong><cfoutput>#replace(trim(LvarResultado),"\n","<BR>","all")#</cfoutput></strong></td>

		</tr>            

	</table>

</cfif>

<cffunction name="fnJSStringFormat" output="false" returntype="string" access="private">
	<cfargument name="hilera" type="string" required="yes">
	
	<cfinvoke 
		 component="sif.Componentes.PC_GeneraCuentaFinanciera"
		 method="fnJSStringFormat"
		 returnvariable="LvarHilera"

		 hilera="#Arguments.hilera#" 
	 />
	<cfreturn LvarHilera>
</cffunction>
