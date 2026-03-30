
<!--- <cf_dump var="#Form#"> --->

<cfif isdefined("form.Archivo")>
  <cftry>
	<cfset RunningLogPath = ExpandPath("#Form.Archivo#")>
	<cfset CrLf = chr(10) & chr(13)> 
	  <cfif FileExists(RunningLogPath)>
		   <cffile action="read" file="#RunningLogPath#" variable="myfile">
		   <cfloop list="#myfile#" index="run" delimiters="#CrLf#">
			 <cfset cambio = replace(#run#,"|",",","All")>
	<!---            <cfoutput>#cambio#<br/></cfoutput>  --->
				<cfset TipoLin = mid(#cambio#,1,1)>
				<cfif TipoLin eq "E">
					  <cfloop from="1" to="#ListLen(cambio)#" index="i">
			 <!---             <cfoutput>#ListGetAt(cambio,i)#<br/></cfoutput>  --->
							  <cfif i eq 2>
								  <cfset Fecha1 = #ListGetAt(cambio,i)#> 
								  <cfset OTFReg = CreateDate(mid(Fecha1,5,4),mid(Fecha1,3,2),mid(Fecha1,1,2))>                     
							  </cfif>
							  <cfif i eq 3> 
								  <cfset Fecha2 = #ListGetAt(cambio,i)#> 
								  <cfset OTFEnt = CreateDate(mid(Fecha2,5,4),mid(Fecha2,3,2),mid(Fecha2,1,2))>
							  </cfif>
							  <cfif i eq 4> <cfset OTCodCte = #ListGetAt(cambio,i)#> </cfif>
							  <cfif i eq 5> <cfset OT = #ListGetAt(cambio,i)#> </cfif>
							  <cfif i eq 6> <cfset OTDescr = #ListGetAt(cambio,i)#> </cfif>
							  <cfset OTObser = "">
							  <cfif i eq 7> <cfset OTObser = #ListGetAt(cambio,i)#> </cfif>
					  </cfloop>
					  <cfquery name="RsInsOT" datasource="#Session.DSN#"> 			<!--- Inserta la OT --->
						  insert into Prod_OT (Ecodigo,OTcodigo,SNCodigo,OTdescripcion,OTfechaRegistro,OTfechaCompromiso,OTobservacion,OTstatus)
							  values (
									  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
									  <cfqueryparam cfsqltype="cf_sql_varchar" value="#OT#">,
									  <cfqueryparam cfsqltype="cf_sql_integer" value="#OTCodCte#">,
									  <cfqueryparam cfsqltype="cf_sql_varchar" value="#OTDescr#">,
									  <cfqueryparam cfsqltype="cf_sql_date" value="#OTFReg#">,
									  <cfqueryparam cfsqltype="cf_sql_date" value="#OTFEnt#">,
									  <cfqueryparam cfsqltype="cf_sql_text" value="#OTObser#">,
									  <cfqueryparam cfsqltype="cf_sql_char" value="NUEVA">
									  )
					  </cfquery> 
					  
				<cfelseif TipoLin eq "P">
					  <cfloop from="1" to="#ListLen(cambio)#" index="i">
				  <!---         <cfoutput>#ListGetAt(cambio,i)#<br/></cfoutput> --->
							  <cfif i eq 2> <cfset PPSecA = #ListGetAt(cambio,i)#> </cfif>
							  <cfif i eq 3> <cfset PPCodA = #ListGetAt(cambio,i)#> </cfif>
					  </cfloop>
					  <cfquery name="RsInsProdProceso" datasource="#Session.DSN#">		<!--- Inserta el Proceso de Produccion --->
						  insert into Prod_Proceso (Ecodigo,OTcodigo,OTseq,APcodigo,OTstatus)
							  values(
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#OT#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#PPSecA#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#PPCodA#">,
									 <cfqueryparam cfsqltype="cf_sql_char" value="PROCESO">
									  )
					  </cfquery> 
					  
				<cfelseif TipoLin eq "M">
					  <cfloop from="1" to="#ListLen(cambio)#" index="i">
				 <!---         <cfoutput>#ListGetAt(cambio,i)#<br/></cfoutput> --->
							  <cfif i eq 2> <cfset PISecA = #ListGetAt(cambio,i)#> </cfif>
							  <cfif i eq 3> <cfset PICodPro = #ListGetAt(cambio,i)#> </cfif>
							  <cfif i eq 4> <cfset PICosto = #ListGetAt(cambio,i)#> </cfif>
							  <cfif i eq 5> <cfset PICant = #ListGetAt(cambio,i)#> </cfif>
							  <cfif i eq 6> <cfset PICodU = #ListGetAt(cambio,i)#> </cfif>
					  </cfloop>
					  <cfquery name="RsInsProdInsumo" datasource="#Session.DSN#">
						  insert into Prod_Insumo (Ecodigo,OTcodigo,OTseq,Artid,UCodigo,MPcantidad,MPprecioUnit,MPseguimiento) <!--- Inserta el Insumo --->
							  values(
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#OT#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#PISecA#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#PICodPro#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PICodU#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#PICant#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#PICosto#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#1#">
									  )
					  </cfquery> 
		  
					  
				<cfelseif TipoLin eq "N">
					  <cfloop from="1" to="#ListLen(cambio)#" index="i">
			   <!---           <cfoutput>#ListGetAt(cambio,i)#<br/></cfoutput>  --->
							  <cfif i eq 2> <cfset PTCodPro = #ListGetAt(cambio,i)#> </cfif>
							  <cfif i eq 3> <cfset PTCosto = #ListGetAt(cambio,i)#> </cfif>
							  <cfif i eq 4> <cfset PTCant = #ListGetAt(cambio,i)#> </cfif>
					  </cfloop>
					  <cfquery name="RsInsProdProducto" datasource="#Session.DSN#">
						  insert into Prod_Producto (Ecodigo,OTcodigo,Artid,PTcantidad,PTPrecioUnit)	<!--- Inserta el producto Terminado --->
							  values(
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#OT#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#PTCodPro#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#PTCant#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#PTCosto#">
									  )
					  </cfquery>                         
				</cfif>
				  
		   </cfloop>
	  <cfelse>
		   No es el Archivo indicado, No puedes Importarlo
	  </cfif>
      
    <cfcatch type="any">
    	<cfinclude template="../../../sif/errorPages/BDerror.cfm">
    	<cfabort>
    </cfcatch>
  </cftry>
      
</cfif>

<form action="ImportadorOT.cfm" method="post" name="sql">
</form>

<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>


