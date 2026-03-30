<cfset smpp = CreateObject ("Component", "home.Componentes.SMPP" ) >

<cfset smpp.bind()>
<cfset smpp.submit_sm("8381218", "Esto es una prueba")>
<cfset smpp.unbind()>
