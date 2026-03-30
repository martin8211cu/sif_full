<cfset listaCod= ArrayNew(1)>
<cfif isdefined("form.Usucodigo") and  len(trim(form.Usucodigo))>
	<cfset codigos=form.Usucodigo>
	<cfset listaCod=codigos.split(',')>
<cfelse>
	<script>
		alert('No se pueden importar los datos.');
		history.back();
    </script>
</cfif>
<cfset tmpini=0>
<cfif arrayLen(listaCod) GT 1>
    <cfquery datasource="#session.dsn#" name="rsListaExport">
        select cf.CFcodigo, u.Usulogin,cps.CPSUconsultar , cps.CPSUtraslados ,
        cps.CPSUreservas , cps.CPSUformulacion , cps.CPSUaprobacion,
        ( select cft.CFcodigo from CFuncional cft inner join CPSeguridadUsuario su on cft.CFid= su.CFid and su.CPSUid=cps.CPSUidOrigen  ) as CPSUidOrigen
        from 
        Usuario u left join CPSeguridadUsuario cps on cps.Usucodigo=u.Usucodigo
        join CFuncional cf on cf.CFid=cps.CFid
        where 
        cps.Ecodigo=#session.Ecodigo#
        and u.CEcodigo=#session.CEcodigo#
        and (
        <cfloop index="x" from="1" to="#arrayLen(listaCod)#">
        	<cfset temp=listaCod[x]>
        	<cfif (len(temp) NEQ 0) and (temp NEQ "") and (tmpini EQ 0)><cfset tmpini=1>            
        		<cfoutput>u.Usucodigo=#temp#</cfoutput>
            <cfelseif (len(temp) NEQ 0) and (temp NEQ "") and (tmpini NEQ 0)>
            	<cfoutput> or u.Usucodigo=#temp#</cfoutput>
            </cfif>
        </cfloop>
        )
        order by u.Usucodigo, u.Usulogin desc
    </cfquery>
    
    
    <!--- Formato Excel --->
    <cfif isdefined("form.format") and len(trim(form.format)) and form.format EQ "Excel">
         <cf_QueryToFile query="#rsListaExport#" FILENAME="ListaExportPermisosUser.xls" titulo="Lista de Exportacion de Permisos de Usuarios">
    <cfelse><!--- formato html --->
    <script>
			top.consoleRef=window.open("",null,"height=400,width=600,status=yes,toolbar=yes,menubar=no,location=no,resizable=yes");
			top.consoleRef.document.writeln(
			'<br /> <style type="text/css">.tituloListas {background-color: #D7DCE0;}</style>'
			+'<table width="95%"  border="0" cellspacing="2" cellpadding="3" align="center">'
			+'<tr>'
            +'<td class="titulolistas">Codigo Centro Funcional</td>'
            +'<td class="titulolistas">Login</td>'
            +'<td class="titulolistas">Consultar</td>'
            +'<td class="titulolistas">Traslados</td>'
            +'<td class="titulolistas">Reservas</td>'
            +'<td class="titulolistas">Formulaci&oacute;n</td>'
			+'<td class="titulolistas">Aprobacion</td>'
            +'<td class="titulolistas">Centro Funcional Padre</td>'
        	+'</tr><tr><td colspan="8">'
			+'<textarea style="height: 400px; width: 100%;">'
			<cfoutput query="rsListaExport">
			+'#CFcodigo#,'
            +'#Usulogin#,'
			+'#CPSUconsultar#,'
			+'#CPSUtraslados#,'
			+'#CPSUreservas#,'
			+'#CPSUformulacion#,'
			+'#CPSUaprobacion#,'
            +'<cfif (len(CPSUidOrigen) EQ 0)>NULL<cfelse>#CPSUidOrigen#</cfif>\n'                         
			
       </cfoutput>
       		+'</textarea></td></tr></table>'
			);
			top.consoleRef.document.close();
			
			history.back();
			setTimeout("window.document.location.href='exportar_permisosUser.cfm'",1000);
			</script>
    </cfif>
    
</cfif>
