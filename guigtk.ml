open GMain
open GdkKeysyms


let locale = GtkMain.Main.init ()

let main () =
  let window = GWindow.window ~width:320 ~height:320
      ~title:"Simple lablgtk programi cry" () in
  let vbox = GPack.vbox ~packing:window#add () in
  window#connect#destroy ~callback:Main.quit;

  (* Menu bar *)
  let menubar = GMenu.menu_bar ~packing:vbox#pack () in
  let factory = new GMenu.factory menubar in
  let accel_group = factory#accel_group in
  let file_menu = factory#add_submenu "File" in

  let box1 = GPack.vbox ~spacing:10 ~border_width:10 ~packing:vbox#add () in
  let box2 = GPack.vbox ~spacing:10 ~border_width:10 ~packing:vbox#add () in
  let box3 = GPack.vbox ~spacing:10 ~border_width:10 ~packing:vbox#add () in
  let label = GMisc.label ~text:"<empty>" ~selectable:true ~line_wrap:true
   ~justify:`CENTER ~packing:(box1#pack ~expand:true) () in


  (* File menu *)
  let factory = new GMenu.factory file_menu ~accel_group in
  factory#add_item "Quit" ~key:_Q ~callback: Main.quit;

  let t = "Change text" in
  (* Button *)
  let button = GButton.button ~label:"Push me!"
      ~packing:box2#add () in
  button#connect#clicked ~callback: (fun () ->
      match GToolbox.input_text ~title:t t with
      | Some text -> label#set_text text
      | None -> ());


  let button1 = GButton.radio_button ~label:"button1"
      ~packing:box3#add () in

  let button2 = GButton.radio_button ~group:button1#group ~label:"button2"
       ~active:true ~packing:box3#add () in

   let button3 = GButton.radio_button
       ~group:button1#group ~label:"button3" ~packing:box3#add () in

  (* Display the windows and enter Gtk+ main loop *)
  window#add_accel_group accel_group;
  window#show ();
  Main.main ()

let () = main ()
