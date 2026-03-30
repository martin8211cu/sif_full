<cfflush interval="16">

<cfquery name = "rsCantidad" datasource="asp_db2">
	select count(1) as Cantidad
    from UsuarioRol
</cfquery>

<cfquery datasource="asp_db2">
	delete 
    from UsuarioRol
    where Usucodigo = 27
</cfquery>


<cfquery name="usuariosasp" datasource="asp">
	select 
	    Usucodigo, Ecodigo, SScodigo, SRcodigo
    from UsuarioRol
    where Usucodigo = 27
</cfquery>

<cfloop query="usuariosasp">
	<cfquery datasource="asp_db2">
        insert into UsuarioRol 
        (Usucodigo, Ecodigo, SScodigo, SRcodigo)
        values (#Usucodigo#, #Ecodigo#, '#SScodigo#', '#SRcodigo#')
    </cfquery>
    <cftransaction action="commit" />
	<cfoutput>#Usucodigo#</cfoutput><br />
</cfloop>
LISTO UsuarioRol!!!!
<cfabort>
<cfreturn>



<cfquery name = "rsCantidad" datasource="asp_db2">
	select count(1) as Cantidad
    from Usuario
</cfquery>

Cantidad de Registros de Usuario Existentes: <cfoutput>#rsCantidad.Cantidad#</cfoutput>
<br />
<br />

<cfquery datasource="asp_db2">
	delete from UsuarioPassword
</cfquery>


<cfquery datasource="asp_db2">
	delete from Usuario
</cfquery>


<cfquery name="usuariosasp" datasource="asp">
	select 
    	Usucodigo, 
    	CEcodigo, 
        id_direccion, 
        datos_personales, 
        LOCIdioma, 
        Usulogin, 
        admin, 
        Ureferencia1, 
        Ureferencia2, 
        Ureferencia3, 
        BMfecha, 
        BMUsucodigo, 
        Uestado, 
        Utemporal, 
        Ufdesde, 
        Ufhasta, 
        Usupregunta, 
        Usurespuesta, 
        ts_rversion, 
        Ubloqueo
    from Usuario
    order by Usucodigo
</cfquery>


<cfloop query="usuariosasp">
	<cfquery datasource="asp_db2">
        insert into Usuario 
        (Usucodigo, CEcodigo, id_direccion, datos_personales, LOCIdioma, Usulogin, admin, Ureferencia1, Ureferencia2, Ureferencia3, BMfecha, BMUsucodigo, Uestado, Utemporal, Ufdesde, Ufhasta, Usupregunta, Usurespuesta, Ubloqueo)
        values (
        #Usucodigo#, 
        #CEcodigo#, 
        #id_direccion#, 
        <cfif len(datos_personales)>#datos_personales#<cfelse>null</cfif>, 
        '#LOCIdioma#', 
        '#Usulogin#', 
        #admin#, 
        '#Ureferencia1#', 
        '#Ureferencia2#', 
        '#Ureferencia3#', 
        '#BMfecha#', 
        #BMUsucodigo#, 
        #Uestado#, 
        #Utemporal#, 
        '#Ufdesde#', 
        '#Ufhasta#', 
        '#Usupregunta#', 
        '#Usurespuesta#', 
        null)
    </cfquery>
    <cftransaction action="commit" />
	<cfoutput>#Usucodigo#</cfoutput><br />
	<cfoutput>#Usulogin#</cfoutput><br />
</cfloop>
LISTO Usuario!!!!

<cfquery name="rsUsuarioPassword" datasource="asp">
	select Usucodigo, Usulogin, Hash, HashMethod, PasswordSalt, SessionData, SessionExpires, TicketData, TicketExpires, AllowedAccess, PasswordSet
    from UsuarioPassword
</cfquery>

<cfloop query="rsUsuarioPassword">
	<cfquery datasource="asp_db2">
    	insert into UsuarioPassword 
			(
            	Usucodigo, 
                Usulogin, 
                Hash, 
                HashMethod, 
                PasswordSalt, 
                SessionData, 
                SessionExpires, 
                TicketData, 
                TicketExpires, 
                AllowedAccess, 
                PasswordSet)
		values ( 
        		#Usucodigo#, 
                '#Usulogin#', 
                '#tostring(Hash)#', 
                '#HashMethod#', 
                '#ToString(PasswordSalt)#', 
                '#SessionData#', 
                <cfif len(SessionExpires)>#SessionExpires#<cfelse>null</cfif>, 
                '#TicketData#', 
                <cfif len(TicketExpires)>#TicketExpires#<cfelse>null</cfif>, 
                #AllowedAccess#, 
                '#PasswordSet#')
    </cfquery>
	<cfoutput>#Usucodigo#</cfoutput><br />
	<cfoutput>#Usulogin#</cfoutput><br />
</cfloop>

LISTO Password!!!!

<cfquery name = "rsCantidad" datasource="asp_db2">
	select count(1) as Cantidad
    from UsuarioProceso
</cfquery>

<cfquery datasource="asp_db2">
	delete 
    from UsuarioProceso
    where Usucodigo = 27
</cfquery>


<cfquery name="usuariosasp" datasource="asp">
	select 
	    Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo, UPtipo
    from UsuarioProceso
    where Usucodigo = 27
</cfquery>


<cfloop query="usuariosasp">
	<cfquery datasource="asp_db2">
        insert into UsuarioProceso 
        (Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo, UPtipo)
        values (#Usucodigo#, #Ecodigo#, '#SScodigo#', '#SMcodigo#', '#SPcodigo#', '#UPtipo#')
    </cfquery>
    <cftransaction action="commit" />
	<cfoutput>#Usucodigo#</cfoutput><br />
</cfloop>
LISTO UsuarioProceso!!!!


<cfset LvarCantidad = 0>

<cfquery datasource="asp_db2">
	delete from SComponentes
</cfquery>

<cfquery name="rsSComponentes" datasource="asp">
	select SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo
    from SComponentes
</cfquery>

<cfloop query="rsSComponentes">
	<cfquery datasource="asp_db2">
		insert into SComponentes 
		(SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
		values ('#SScodigo#', '#SMcodigo#', '#SPcodigo#', '#SCuri#', '#SCtipo#', #SCauto#, '#BMfecha#', #BMUsucodigo#)
	</cfquery>
    <cfset LvarCantidad = LvarCantidad + 1>
    <cfif LvarCantidad mod 10 eq 0>
    	<cfoutput>#LvarCantidad#</cfoutput><br />
    </cfif>
</cfloop>

LISTO SComponentes!!!! <cfoutput>#LvarCantidad#</cfoutput><br />

<cfset LvarCantidad = 0>

<cfquery datasource="asp_db2">
	delete from vUsuarioProcesos
</cfquery>

<cfquery name="rsSComponentes" datasource="asp">
	select Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo
    from vUsuarioProcesos
    where Usucodigo in (1, 15, 27, 9687)
</cfquery>

<cfloop query="rsSComponentes">
	<cfquery datasource="asp_db2">
		insert into vUsuarioProcesos
		(Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo)
        values (#Usucodigo#, #Ecodigo#, '#SScodigo#', '#SMcodigo#', '#SPcodigo#')
	</cfquery>
    <cfset LvarCantidad = LvarCantidad + 1>
    <cfif LvarCantidad mod 10 eq 0>
    	<cfoutput>#LvarCantidad#</cfoutput><br />
    </cfif>
</cfloop>

LISTO VusuarioProcesos!!!! <cfoutput>#LvarCantidad#</cfoutput><br />

<cfset LvarCantidad = 0>

<!---
<cfquery datasource="asp_db2">
    create table VSidioma(
      Iid numeric(18,0) not null,
      VSgrupo integer not null,
      VSvalor char(40) not null,
      VSdesc varchar(255) not null,
      ts_rversion timestamp null
    )
</cfquery>
--->

<cfquery datasource="asp_db2">
	delete from VSidioma
</cfquery>

<cfquery name="rsSComponentes" datasource="asp">
	select Iid, VSgrupo, VSvalor, VSdesc
    from VSidioma
</cfquery>

<cfloop query="rsSComponentes">
	<cfquery datasource="asp_db2">
        insert into VSidioma 
            (Iid, VSgrupo, VSvalor, VSdesc)
        values (#Iid#, #VSgrupo#, '#VSvalor#', '#VSdesc#')
	</cfquery>
    <cfset LvarCantidad = LvarCantidad + 1>
    <cfif LvarCantidad mod 10 eq 0>
    	<cfoutput>#LvarCantidad#</cfoutput><br />
    </cfif>
</cfloop>

LISTO VSidioma!!!! <cfoutput>#LvarCantidad#</cfoutput><br />

<cfabort>
