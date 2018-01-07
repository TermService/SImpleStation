
// File:    overlays.dm
// Library: Forum_account.Overlays
// Author:  Forum_account
//
// Contents:
//   This library provides an easy way to manage overlays on all
//   types of atoms. It defines two things. First is the overlay()
//   proc which is defined for all types of atoms. This proc has
//   three forms:
//
//     overlay('icon file.dmi')
//     overlay('icon file.dmi', "icon state")
//     overlay("icon state")
//
//   The proc creates an overlay on the src atom using the specified
//   icon and icon state. If no state is specified, the state of the
//   overlay will match the src atom's state. If no icon is specified,
//   it will use the src atom's icon.
//
//   The overlay() proc returns an /Overlay object which can be used
//   to modify the overlay. This object has many procs you can use to
//   modify the overlay. For example, you can call overlay.Hide() or
//   overlay.Show() to hide and show it. You don't need to access the
//   atom's overlays list directly, the /Overlay object has procs to
//   handle that.
//
//   The /Overlay object has these procs to control if the overlay
//   is shown. None of them take any arguments.
//
//     Hide
//     Show
//     Toggle
//
//   The /Overlay object has these procs to controls its display
//   properties. Each takes zero or one arguments. If no argument is
//   specified, the proc returns the current value. If an argument is
//   specified, the proc sets the property to the new value.
//
//     Icon
//     IconState
//     PixelX
//     PixelY
//     PixelZ
//     Layer
//
//   The /Overlay object also has the Flick proc, which takes two
//   arguments: an icon state and a duration. It animates just this
//   overlay. This is something that BYOND's overlays aren't capable
//   of, you can only animate them if you animate the mob (which will
//   animate all overlays).
//
//     Flick
//
//   Check demo\demo.dm for an example of how to use this library. To
//   run the demo include both demo\demo.dm (the demo code) and
//   demo\demo.dmm (the demo map) and run the project.

atom
	var
		list/flicked_overlays
		list/flicked_overlay_pool

	proc
		overlay(icon, icon_state = null, layer = null)

			// if the first argument is text, treat it as
			// the icon_state
			if(istext(icon))
				icon_state = icon
				icon = null

				// if no icon is specified, use the atom's icon
				if(isnull(icon))
					icon = src.icon

			return new /Overlay(src, icon, icon_state, layer)

atom
	movable
		Move()
			. = ..()

			if(.)
				if(flicked_overlays)
					for(var/obj/o in flicked_overlays)
						o.pixel_step_size = pixel_step_size
						o.Move(loc, dir)
						o.step_x = step_x
						o.step_y = step_y

				if(flicked_overlay_pool)
					for(var/obj/o in flicked_overlay_pool)
						o.pixel_step_size = pixel_step_size
						o.Move(loc, dir)
						o.step_x = step_x
						o.step_y = step_y
/*
mob
	pixel_move()
		..()

		if(move_x || move_y)
			if(flicked_overlays)
				for(var/obj/o in flicked_overlays)
					o.pixel_step_size = pixel_step_size
					o.Move(loc, dir)
					o.step_x = px - x * icon_width
					o.step_y = py - y * icon_height

			if(flicked_overlay_pool)
				for(var/obj/o in flicked_overlay_pool)
					o.pixel_step_size = pixel_step_size
					o.Move(loc, dir)
					o.step_x = px - x * icon_width
					o.step_y = py - y * icon_height
*/

Overlay
	var
		atom/owner
		obj/overlay_obj
		image/image_obj
		visible = 1

		rgb = ""
		list/viewers
		image = 0

		maptext_width = 32
		maptext_height = 32

	New(mob/o, icon, icon_state = null, layer = null)

		overlay_obj = new()
		overlay_obj.icon = icon

		if(layer != null)
			overlay_obj.layer = layer
		else
			overlay_obj.layer = o.layer

		overlay_obj.maptext_width = 32
		overlay_obj.maptext_height = 32

		owner = o

		if(icon_state != null)
			overlay_obj.icon_state = icon_state

		owner.overlays += overlay_obj

	Del()
		owner.overlays -= overlay_obj
		..()

	proc
		Move(atom/new_owner)

			if(owner)
				owner.overlays -= overlay_obj

			if(image)
				del image_obj

				image_obj = image(overlay_obj.icon, new_owner, overlay_obj.icon_state, overlay_obj.layer)
				image_obj.pixel_x = overlay_obj.pixel_x
				image_obj.pixel_y = overlay_obj.pixel_y
				image_obj.pixel_z = overlay_obj.pixel_z

			owner = new_owner

			if(owner && visible)
				if(image)
					for(var/client/c in viewers)
						c.images += image_obj
				else
					owner.overlays += overlay_obj

		// Get the next available object we can use to create
		// an animated overlay. This method will initialize the
		// pool of objects or add a new object if none are
		// available.
		__get_flick_obj()

			// initialize owner.flicked_overlay_pool if we need to
			if(!owner.flicked_overlays)
				owner.flicked_overlays = list()

			if(!owner.flicked_overlay_pool)
				owner.flicked_overlay_pool = list()
				for(var/i = 1 to 3)
					var/obj/o = new /obj(owner.loc)
					o.invisibility = 101
					o.layer = overlay_obj.layer
					owner.flicked_overlay_pool += o

			// If the pool is empty, add another object
			if(!owner.flicked_overlay_pool.len)
				var/obj/o = new /obj(owner.loc)
				o.invisibility = 101
				o.layer = 0
				owner.flicked_overlay_pool += o

			// grab an object from the pool and use it as the flicked overlay
			var/obj/o = owner.flicked_overlay_pool[1]
			owner.flicked_overlay_pool.Cut(1,2)

			o.layer = overlay_obj.layer + 0.001
			o.animate_movement = SYNC_STEPS
			o.invisibility = owner.invisibility

			return o

		Hide()
			if(!visible) return 0

			visible = 0

			if(image)
				if(image_obj)
					for(var/client/c in viewers)
						c.images -= image_obj
			else
				owner.overlays -= overlay_obj

			return 1

		Show()
			if(visible) return 0

			visible = 1

			if(image)
				if(image_obj)
					for(var/client/c in viewers)
						c.images += image_obj
			else
				owner.overlays += overlay_obj

			return 1

		Toggle()
			if(visible)
				return Hide()
			else
				return Show()

		Icon()
			if(args.len)

				// if we have an image object we want to update it whether
				// it's being shown or not. If it's not currently shown, we
				// need to update it so it's up-to-date when we do show it.
				if(image_obj)

					// this can cause a delay so we need to spawn it
					spawn()
						image_obj.icon = args[1]

				// if we are currently displaying the image object, we only
				// need to update the overlay (we don't need to subtract it
				// and add it back).
				if(image)
					overlay_obj.icon = args[1]

				// otherwise, we're showing the overlay and need to update it
				// as we normally would (subtract it, update it, add it back)
				else
					if(visible) owner.overlays -= overlay_obj
					overlay_obj.icon = args[1]
					if(visible) owner.overlays += overlay_obj
			else
				return overlay_obj.icon

		IconState()
			if(args.len)

				if(image_obj)
					spawn()
						image_obj.icon_state = args[1]

				if(image)
					overlay_obj.icon_state = args[1]

				else
					if(visible) owner.overlays -= overlay_obj
					overlay_obj.icon_state = args[1]
					if(visible) owner.overlays += overlay_obj
			else
				return overlay_obj.icon_state

		PixelX()
			if(args.len)

				if(image_obj)
					spawn()
						image_obj.pixel_x = args[1]

				if(image)
					overlay_obj.pixel_x = args[1]

				else
					if(visible) owner.overlays -= overlay_obj
					overlay_obj.pixel_x = args[1]
					if(visible) owner.overlays += overlay_obj
			else
				return overlay_obj.pixel_x

		PixelY()
			if(args.len)

				if(image_obj)
					spawn()
						image_obj.pixel_y = args[1]

				if(image)
					overlay_obj.pixel_y = args[1]

				else
					if(visible) owner.overlays -= overlay_obj
					overlay_obj.pixel_y = args[1]
					if(visible) owner.overlays += overlay_obj
			else
				return overlay_obj.pixel_y

		PixelZ()
			if(args.len)
				if(image_obj)
					spawn()
						image_obj.pixel_z = args[1]

				if(image)
					overlay_obj.pixel_z = args[1]

				else
					if(visible) owner.overlays -= overlay_obj
					overlay_obj.pixel_z = args[1]
					if(visible) owner.overlays += overlay_obj
			else
				return overlay_obj.pixel_z

		Layer()
			if(args.len)
				if(image_obj)
					spawn()
						image_obj.layer = args[1]

				if(image)
					overlay_obj.layer = args[1]

				else
					if(visible) owner.overlays -= overlay_obj
					overlay_obj.layer = args[1]
					if(visible) owner.overlays += overlay_obj
			else
				return overlay_obj.layer

		RGB()
			if(args.len == 0)
				return rgb

			var/color

			if(args.len == 1)
				if(istext(args[1]))
					color = args[1]
				else
					return null
			else if(args.len == 3)
				color = rgb(args[1], args[2], args[3])
			else if(args.len == 4)
				color = rgb(args[1], args[2], args[3], args[4])

			if(visible) owner.overlays -= overlay_obj
			if(rgb) overlay_obj.icon -= rgb
			overlay_obj.icon += color
			if(visible) owner.overlays += overlay_obj

			rgb = color

		ShowTo(mob/m)

			// convert the argument to a client
			var/client/c

			if(istype(m))
				c = m.client
			else if(istype(m, /client))
				c = m

			if(!c) return 0

			if(!viewers)
				viewers = list()

			if(c in viewers) return 0

			// initialize the image object if we need to
			if(!image_obj)
				image_obj = image(overlay_obj.icon, owner, overlay_obj.icon_state, overlay_obj.layer)
				image_obj.pixel_x = overlay_obj.pixel_x
				image_obj.pixel_y = overlay_obj.pixel_y
				image_obj.pixel_z = overlay_obj.pixel_z

				image_obj.maptext_width = overlay_obj.maptext_width
				image_obj.maptext_height = overlay_obj.maptext_height
				image_obj.maptext = overlay_obj.maptext

			// if we weren't already showing the image object that means we may
			// need to remove the overlay.
			if(!image)
				if(visible)
					owner.overlays -= overlay_obj

			image = 1
			viewers += c

			// if the image object should be visible, add it to this client's view
			if(visible)
				c.images += image_obj

			return 1

		HideFrom(mob/m)

			// convert the argument to a client
			var/client/c

			if(istype(m))
				c = m.client
			else if(istype(m, /client))
				c = m

			if(!c) return 0

			if(!viewers)
				viewers = list()

			if(!(c in viewers)) return 0

			viewers -= c

			// if the overlay doesn't have any exclusive viewers left, we need to
			// switch back to using an overlay instead of using the image object.
			if(!viewers.len)
				image = 0

			// if we're still showing the image that means we still have exclusive
			// viewers left so we only remove the image object from this client's view
			if(image)
				c.images -= image_obj

			// otherwise we're switching back to the overlay and add the overlay
			// if it should be visible (ex: they haven't called Hide()).
			else
				if(visible)
					owner.overlays += overlay_obj

		ShowToAll()
			for(var/client/c in viewers)
				HideFrom(c)

		Text()
			if(args.len)
				if(image_obj)
					spawn()
						image_obj.maptext_width = maptext_width
						image_obj.maptext_height = maptext_height
						image_obj.maptext = args[1]

				if(image)
					overlay_obj.maptext = args[1]

				else
					if(visible) owner.overlays -= overlay_obj
					overlay_obj.maptext = args[1]
					if(visible) owner.overlays += overlay_obj
			else
				return overlay_obj.maptext

		MapText()
			Text(arglist(args))

		TextBounds(w, h)
			if(!h) h = w

			maptext_width = w
			maptext_height = h

			if(image_obj)
				spawn()
					image_obj.maptext_width = w
					image_obj.maptext_height = w

			if(image)
				overlay_obj.maptext_width = w
				overlay_obj.maptext_height = h

			else
				if(visible) owner.overlays -= overlay_obj
				overlay_obj.maptext_width = w
				overlay_obj.maptext_height = h
				if(visible) owner.overlays += overlay_obj

		Flick(is, duration)

			if(!visible) return

			if(duration == null)
				CRASH("Flick requires 2 arguments, the second is the duration of the animation.")

			if(image)
				CRASH("The library does not support animated overlays with exclusive viewers.")
			else
				var/obj/o = __get_flick_obj()

				o.icon = overlay_obj.icon
				o.dir = owner.dir
				o.pixel_x = owner.pixel_x
				o.pixel_y = owner.pixel_y
				o.pixel_z = owner.pixel_z
				if(istype(owner, /atom/movable))
					o.step_x = owner:step_x
					o.step_y = owner:step_y

				visible -= 1
				owner.flicked_overlays += o

				owner.overlays -= overlay_obj
				flick(is, o)

				sleep(duration)

				owner.flicked_overlays -= o
				owner.flicked_overlay_pool += o
				o.invisibility = 101
				o.layer = 0

				visible += 1
				if(!image && visible > 0)
					owner.overlays += overlay_obj