<cfparam name="action" default="Importador.cfm">
<cfparam name="modo" default="CAMBIO">
<cfparam name="dmodo" default="ALTA">
<cftransaction>
<cfif not isdefined("form.NuevoD")>
		<cfif isdefined("form.AltaE")>		<!--- Caso 1: Agregar Encabezado --->
			<cfquery name="alta_eimportador" datasource="sifcontrol">
			insert into EImportador (
				EIcodigo, EImodulo, Ecodigo, EIdescripcion,
				EIdelimitador, EImod_login, EImod_fecha, EImod_usucodigo,
				EImod_ulocalizacion, EIusatemp, EItambuffer, EIparcial,
				EIverificaant, EIimporta, EIexporta, EIcfimporta, EIcfexporta,EIcfparam, charset)
			values ( <cfqueryparam value="#form.EIcodigo#" cfsqltype="cf_sql_char">,
					 <cfqueryparam value="#form.EImodulo#" cfsqltype="cf_sql_char">,
					 null,
					 <cfqueryparam value="#form.EIdescripcion#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="#form.EIdelimitador#" cfsqltype="cf_sql_char">,
					 <cfqueryparam value="#session.usuario#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#session.Ulocalizacion#" cfsqltype="cf_sql_char">,
					 <cfif isdefined("EIusatemp")>1<cfelse>0</cfif>,
					 <cfqueryparam value="#form.EItambuffer#" cfsqltype="cf_sql_integer">,
					 <cfif isdefined("EIparcial")>1<cfelse>0</cfif>,
					 <cfqueryparam value="#form.EIverificaant#" cfsqltype="cf_sql_integer">,
					 <cfif isdefined("EIimporta")>1<cfelse>0</cfif>,
					 <cfif isdefined("EIexporta")>1<cfelse>0</cfif>,
					 <cfqueryparam value="#form.EIcfimporta#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="#form.EIcfexporta#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="#form.EIcfparam#" cfsqltype="cf_sql_varchar">,
					 <cfif form.EIcharset eq 0>
					 'utf-8'
					 <cfelseif form.EIcharset eq 1>
					 'utf-16'
					 <cfelseif form.EIcharset eq 2>
					 'iso-8859-1'
					 <cfelseif form.EIcharset eq 3>
					 'windows-1252'
					 </cfif>
				   )
			<cf_dbidentity1 datasource="sifcontrol" name="alta_eimportador">
			</cfquery>
			<cf_dbidentity2 datasource="sifcontrol" name="alta_eimportador">
			<cfset form.EIid = alta_eimportador.identity>
			<cfquery datasource="sifcontrol">
			insert into EISQL (EIid, EIsql, EIsqlexp)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#alta_eimportador.identity#">,
					 <cfif isdefined("form.EIsql")><cfqueryparam value="#form.EIsql#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
					 <cfif isdefined("form.EIsqlexp")><cfqueryparam value="#form.EIsqlexp#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>
					)
			</cfquery>

		<cfelseif isdefined("form.BajaE")> <!--- Caso 2: Borrar un Encabezado de Importacion --->
			<cfquery datasource="sifcontrol">
			delete from EISQL
			where EIid = <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfquery datasource="sifcontrol">
			delete from DImportador
			where EIid = <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfquery datasource="sifcontrol">
			delete from EImportador
			where EIid = <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset action = "ListaImportador.cfm">
			<cfset modo="ALTA">
			  
		<cfelseif isdefined("form.AltaD") or isdefined("form.CambioD") or isdefined("form.CambioE") > <!--- Caso 3: Agrega detalle de formato y modifica encabezado --->
			<cfif isdefined("form.AltaD") or isdefined("form.CambioD") >
				<cfquery datasource="sifcontrol" name="maximo">
				select coalesce(max(DInumero),0)+1 as maximo
				from DImportador
				where EIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
                and DItiporeg=<cfqueryparam cfsqltype="cf_sql_char" value="#form.DItiporeg#">
				and DInumero > 0
				</cfquery>
				
				<cfif form.DInumero neq form.hDInumero>
				<!--- si existe un registro con el numero que quiero cambiar o insertar, le pone un numero temporal --->
					<cfquery datasource="sifcontrol">
					update DImportador
					set DInumero   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#maximo.maximo#">
					where EIid     = <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">
                	  and DItiporeg=<cfqueryparam cfsqltype="cf_sql_char" value="#form.DItiporeg#">
					  and DInumero = <cfqueryparam value="#form.DInumero#"   cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif isdefined("form.AltaD") >
					<cfquery datasource="sifcontrol">
					insert into DImportador ( EIid, DInumero, DInombre, DIdescripcion, DItipo, DIlongitud,DItiporeg )
					values ( <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">, 
							 <cfqueryparam value="#maximo.maximo#" cfsqltype="cf_sql_integer">, 
							 <cfqueryparam value="#form.DInombre#" cfsqltype="cf_sql_varchar">,
							 <cfqueryparam value="#form.DIdescripcion#" cfsqltype="cf_sql_varchar">,
							 <cfqueryparam value="#form.DItipo#" cfsqltype="cf_sql_char">, 
							 <cfqueryparam value="#form.DIlongitud#" cfsqltype="cf_sql_integer">,
                             <cfqueryparam value="#form.DItiporeg#"   cfsqltype="cf_sql_varchar">
						   )
					</cfquery>
				<cfelse>
					<cfquery datasource="sifcontrol">
					<!--- asigna la nueva llave para el registro que modifique --->
					update DImportador
					set DInumero      =	<cfqueryparam value="#form.DInumero#" cfsqltype="cf_sql_integer">, 
						DInombre      = <cfqueryparam value="#form.DInombre#" cfsqltype="cf_sql_varchar">,
						DIdescripcion = <cfqueryparam value="#form.DIdescripcion#" cfsqltype="cf_sql_varchar">,
						DItipo        = <cfqueryparam value="#form.DItipo#" cfsqltype="cf_sql_char">, 
						DIlongitud    =	<cfqueryparam value="#form.DIlongitud#" cfsqltype="cf_sql_integer"> 
					where EIid     = <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">
                      and DItiporeg = <cfqueryparam  value="#form.DItiporeg#" cfsqltype="cf_sql_char" >
					  and DInumero = <cfqueryparam value="#form.hDInumero#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
				<!--- al registro con numero maximo, le asigna su nuevo numero 
				<cfif form.DInumero neq form.hDInumero>
					<cfquery datasource="sifcontrol">
					update DImportador
					set DInumero   = <cfqueryparam value="#form.hDInumero#"   cfsqltype="cf_sql_integer">
					where EIid     = <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">
                      and DItiporeg=<cfqueryparam  value="#form.DItiporeg#" cfsqltype="cf_sql_char" >
					  and DInumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#maximo.maximo#">
					</cfquery>
				</cfif>
				--->
			</cfif> 
			<cfquery datasource="sifcontrol">
			<!--- Modificar Encabezado --->
			update EImportador
			set EIcodigo      		= <cfqueryparam value="#form.EIcodigo#" cfsqltype="cf_sql_char">,
				EImodulo      		= <cfqueryparam value="#form.EImodulo#" cfsqltype="cf_sql_char">,
				Ecodigo       		= null,
				EIdescripcion 		= <cfqueryparam value="#form.EIdescripcion#" cfsqltype="cf_sql_varchar">,
				EIdelimitador 		= <cfqueryparam value="#form.EIdelimitador#" cfsqltype="cf_sql_char">,
				EImod_login   		= <cfqueryparam value="#session.usuario#" cfsqltype="cf_sql_varchar">,
				EImod_fecha   		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				EImod_usucodigo     = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				EImod_ulocalizacion = <cfqueryparam value="#session.Ulocalizacion#" cfsqltype="cf_sql_char">,
				EIusatemp     		= <cfif isdefined("EIusatemp")>1<cfelse>0</cfif>,
				EItambuffer   		= <cfqueryparam value="#form.EItambuffer#" cfsqltype="cf_sql_integer">,
				EIparcial     		= <cfif isdefined("EIparcial")>1<cfelse>0</cfif>,
				EIverificaant 		= <cfqueryparam value="#form.EIverificaant#" cfsqltype="cf_sql_integer">,
				EIimporta			= <cfif isdefined("EIimporta")>1<cfelse>0</cfif>,
				EIexporta	 		= <cfif isdefined("EIexporta")>1<cfelse>0</cfif>,
				EIcfimporta   		= <cfqueryparam value="#form.EIcfimporta#" cfsqltype="cf_sql_varchar">,
				EIcfexporta   		= <cfqueryparam value="#form.EIcfexporta#" cfsqltype="cf_sql_varchar">,
				EIcfparam   		= <cfqueryparam value="#form.EIcfparam#" cfsqltype="cf_sql_varchar"> , 
				charset           =	 <cfif form.EIcharset eq 0>
										 'utf-8'
										 <cfelseif form.EIcharset eq 1>
										 'utf-16'
										 <cfelseif form.EIcharset eq 2>
										 'iso-8859-1'
										 <cfelseif form.EIcharset eq 3>
										 'windows-1252'
										 </cfif> 
			where EIid     = <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfquery name="rsExist" datasource="sifcontrol">
              select EIsql,EIsqlexp 
                 from EISQL 
              where EIid  = <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric"> 
            </cfquery>             
            <cfif rsExist.recordcount gt 0>
               <cfquery datasource="sifcontrol">
                update EISQL
                set <!--- EIsql    = <cfif isdefined("form.EIsql") ><cfif len(trim(form.EIsql)) gt 0><cfqueryparam value="#form.EIsql#" cfsqltype="cf_sql_varchar"><cfelse>EIsql</cfif><cfelse>null</cfif>, --->
                    EIsql    = <cfif isdefined("form.EIsql") and len(trim(form.EIsql)) gt 0><cfqueryparam value="#form.EIsql#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
                    <!--- EIsqlexp = <cfif isdefined("form.EIsqlexp") ><cfif len(trim(form.EIsqlexp)) gt 0><cfqueryparam value="#form.EIsqlexp#" cfsqltype="cf_sql_varchar"><cfelse>EIsqlexp</cfif><cfelse>null</cfif> --->
                    EIsqlexp = <cfif isdefined("form.EIsqlexp") and len(trim(form.EIsqlexp)) gt 0><cfqueryparam value="#form.EIsqlexp#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>
                where EIid  = <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">
                </cfquery>
             <cfelse>
              <cfquery datasource="sifcontrol">
               insert into EISQL (EIid, EIsql, EIsqlexp)
			   values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">,
					 <cfif isdefined("form.EIsql")><cfqueryparam value="#form.EIsql#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
					 <cfif isdefined("form.EIsqlexp")><cfqueryparam value="#form.EIsqlexp#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>
					)
               </cfquery>     
             </cfif>    
		<cfelseif isdefined("Form.BajaD")> <!--- Caso 4: Borrar una línea del importador --->
			<cfquery datasource="sifcontrol">
			delete from DImportador
			where EIid     = <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">
			  and DInumero = <cfqueryparam value="#form.DInumero#"   cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset action = "Importador.cfm">
		</cfif>

<cfelse>
	<cfset action = "Importador.cfm" >
</cfif>	

</cftransaction>

<cfif isdefined("form.regenerar") and form.regenerar eq 1 and not isdefined("form.NuevoD") and not isdefined("form.BajaE") and not isdefined("form.BajaD") and isdefined("form.EIexporta") and len(trim(form.EIsqlexp)) gt 0 >
	<cfinclude template="SQLExporta.cfm">
</cfif>


<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"     type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="EIid"  type="hidden" value="<cfif isdefined("form.EIid")>#Form.EIid#</cfif>">
	<cfif dmodo neq 'ALTA' ><input name="DInumero"  type="hidden" value="<cfif isdefined("Form.DInumero")>#Form.DInumero#</cfif>"></cfif>
	<input name="Pagina"   type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>