<cfif url.tipo eq 1>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select c.TLCPcedula,c.TLCPnombre,c.TLCPapellido1,TLCPapellido2,b.ETLCnomPatrono,b.ETLCreferencia,a.TLCSreferencia from TLCSincronizar a
		inner join EmpresasTLC b
			on a.TLCSeref = b.ETLCid
		inner join TLCPadronE c
			on a.TLCScedula = c.TLCPcedula 
		where TLCSeref in (#url.RHCGIDLIST#)
		order by c.TLCPnombre,c.TLCPapellido1,TLCPapellido2,c.TLCPcedula
	</cfquery>
<cfelseif url.tipo eq 2>
	<cfset arreglo = listtoarray(url.RHCGIDLIST)>							

	<cf_dbtemp name="Reporte_TEMP" returnvariable="Reporte_TEMP" datasource="#session.dsn#">
		<cf_dbtempcol name="TLCPcedula" type="varchar(10)" mandatory="yes">
		<cf_dbtempcol name="TLCPnombre" type="varchar(100)" mandatory="yes">
		<cf_dbtempcol name="TLCPapellido1" type="varchar(80)" mandatory="yes">
		<cf_dbtempcol name="TLCPapellido2" type="varchar(80)" mandatory="yes">
		<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
			<cf_dbtempcol name="Empresa_#i#"    type="numeric" mandatory="no">
			<cf_dbtempcol name="Referencia_#i#" type="varchar(80)" mandatory="no">
			<cf_dbtempcol name="valor_#i#"      type="varchar(80)" mandatory="no">
		</cfloop>
	</cf_dbtemp>
    
    <cf_dbtemp name="Empresa_TEMP" returnvariable="Empresa_TEMP" datasource="#session.dsn#">
		<cf_dbtempcol name="Nombre" 	type="varchar(80)" mandatory="yes">
        <cf_dbtempcol name="Referencia" type="varchar(80)" mandatory="yes">
        <cf_dbtempcol name="llave" 		type="numeric" mandatory="yes">
        <cf_dbtempcol name="posicion" 	type="integer" mandatory="no">

    </cf_dbtemp>    
    
    <cfquery name="rsinsert" datasource="#session.DSN#">
        insert into  #Empresa_TEMP#  (Nombre,Referencia,llave)
        select 	b.ETLCnomPatrono,
                b.ETLCreferencia,
                b.ETLCid
        from  EmpresasTLC b
        where ETLCid  in (#url.RHCGIDLIST#)    
    </cfquery>    
	<cfquery name="rsinsert" datasource="#session.DSN#">
		insert into #Reporte_TEMP# (TLCPcedula,TLCPnombre,TLCPapellido1,TLCPapellido2)
		select distinct c.TLCPcedula,c.TLCPnombre,c.TLCPapellido1,c.TLCPapellido2
		from TLCSincronizar a
		inner join TLCPadronE c
			on a.TLCScedula = c.TLCPcedula 
		where TLCSeref in (#url.RHCGIDLIST#)
	</cfquery>  
	<cfset llave = 0>
	<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
		<cfset llave = arreglo[i]>
        
        <cfquery name="rsupdate" datasource="#session.DSN#">
				update  #Empresa_TEMP# 
					set posicion =  #i#
				where llave  =   #llave#      
		</cfquery>
	        
        <cfquery name="rsEmpresa" datasource="#session.DSN#">
			select a.TLCScedula,b.ETLCnomPatrono,b.ETLCreferencia,a.TLCSreferencia ,b.ETLCid
			from TLCSincronizar a
				inner join EmpresasTLC b
					on a.TLCSeref = b.ETLCid
			where TLCSeref = #llave#
		 </cfquery>

         <cfloop query="rsEmpresa">
			<cfquery name="rsupdate" datasource="#session.DSN#">
				update  #Reporte_TEMP# 
					set Empresa_#i# =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.ETLCid#" >,
					Referencia_#i#  =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpresa.ETLCreferencia# (#i#)" >,	
					valor_#i#       =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpresa.TLCSreferencia#" >  
				where TLCPcedula =   <cfqueryparam cfsqltype="cf_sql_char" value="#rsEmpresa.TLCScedula#" >        
			</cfquery>
		 </cfloop>
	</cfloop>

	<cfquery name="rsReporte" datasource="#session.DSN#">
		select * from #Reporte_TEMP#
	</cfquery> 
    <cfquery name="rsEmpresas" datasource="#session.DSN#">
		select Nombre,Referencia,llave,posicion from #Empresa_TEMP#
        order by posicion
	</cfquery> 
    
</cfif>

<cfif url.tipo eq 1><!--- Listado--->
	<cfset colspan = 4>
<cfelseif url.tipo eq 2><!--- Tqbular--->
	 <cfset colspan = 2 + arraylen(arreglo) > 
</cfif>

<cfquery name="rsTitulo" datasource="#session.DSN#">
    select Edescripcion from Empresas
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>


<cfif url.Formato eq 1> <!--- Html / Excel --->
	<style type="text/css">
        <!--
        .style1 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 14px;
            font-weight: bold;
        }
        .style6 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 10px;
        }
        .style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }
        
        .style4 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 10px;
            font-weight: bold;
        }
        .style5 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 11px;
            font-weight: bold;
        }
        .style2 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 7px;
            font-weight: bold;
        }
        -->
    </style>	


	<cfset LvarFileName = "Busqueda-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
    <cf_htmlReportsHeaders 
        title="Busqueda" 
        filename="#LvarFileName#"
        preview="no"
        irA="Consultas.cfm" 
        method = "get"
        >
        
    <table width="100%" border="0">
        <tr>
            <td  align="center" colspan="#colspan#"><span class="style3"><cfoutput>#rsTitulo.Edescripcion#</cfoutput></span></td>
        </tr>
        <tr>
            <td colspan="#colspan#" align="center"><span class="style1"><B><cf_translate key="LB_Reporte_por_busqueda_de_referencias">Reporte por busqueda de referencias</cf_translate></B></span></td>
        </tr>
        <tr>
            <td  align="center" colspan="#colspan#">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="#colspan#">
				<cfif url.tipo eq 1><!--- Listado--->
                    <cfinclude template="Reporte1_List.cfm"> 
                <cfelseif url.tipo eq 2><!--- Tqbular--->
                    <cfinclude template="Reporte1_Tab.cfm"> 
                </cfif>
            </td>
        </tr>
    </table>
<cfelse><!--- PDF / FLASH --->
	<cfif url.Formato eq 2>
        <cfset formato = "pdf">
    <cfelseif url.Formato eq 3>
        <cfset formato = "flashpaper">
    </cfif>
   
    <cfdocument format="#formato#" 
        marginleft="2" 
        marginright="2" 
        marginbottom="3"
        margintop="1" 
        unit="cm"  fontembed="yes"
    	pagetype="letter">
		<style type="text/css">
            <!--
            .style1 {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 14px;
                font-weight: bold;
            }
            .style2 {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 9px;
            }
            .style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }
            
            .style4 {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 10px;
                font-weight: bold;
            }
            .style5 {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 11px;
                font-weight: bold;
            }
            .style6 {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 8px;
            }
            -->
        </style>	        
        <table width="100%" border="0">
            <cfdocumentitem type="footer">
                <tr>
                    <td  align="center" colspan="#colspan#"><cfoutput>#rsTitulo.Edescripcion#</cfoutput></td>
                </tr>
            </cfdocumentitem>
            <tr>
                <td  align="center" colspan="#colspan#"><span class="style3"><cfoutput>#rsTitulo.Edescripcion#</cfoutput></span></td>
            </tr>
            <tr>
                <td colspan="#colspan#" align="center"><span class="style1"><B><cf_translate key="LB_Reporte_por_busqueda_de_referencias">Reporte por busqueda de referencias</cf_translate></B></span></td>
            </tr>
            <tr>
                <td  align="center" colspan="#colspan#">&nbsp;</td>
            </tr>
            <tr>
                <td>
                    <cfif url.tipo eq 1><!--- Listado--->
                        <cfinclude template="Reporte1_List.cfm"> 
                    <cfelseif url.tipo eq 2><!--- Tqbular--->
                        <cfinclude template="Reporte1_Tab.cfm"> 
                    </cfif>
                </td>
            </tr>
        </table>
	</cfdocument>
</cfif>