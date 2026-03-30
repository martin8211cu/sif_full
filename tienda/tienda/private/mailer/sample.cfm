<cfinvoke component="tienda.tienda.private.mailer.sendmail" method="sendmail">
	<cfinvokeargument name="template"  value="pedido-recibido.cfm">
	<cfinvokeargument name="pedido"	   value="32">
	<cfinvokeargument name="Ecodigo"   value="147">
	<cfinvokeargument name="DSN"	   value="minisif">	
</cfinvoke>