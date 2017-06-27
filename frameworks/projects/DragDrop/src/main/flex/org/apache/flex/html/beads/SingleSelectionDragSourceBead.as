////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.flex.html.beads
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDragInitiator;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.DragEvent;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Point;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.html.Group;
	import org.apache.flex.html.Label;
	import org.apache.flex.html.beads.controllers.DragMouseController;
	import org.apache.flex.utils.PointUtils;
	
    
	/**
	 *  The SingleSelectionDragSourceBead brings drag capability to single-selection List components.
	 *  By adding this bead, a user can drag a row of the List to a new location within the list. This bead
	 *  should be used in conjunction with SingleSelectionDropTargetBead.
	 * 
     *  @flexjsignoreimport org.apache.flex.core.IDragInitiator
	 *  @see org.apache.flex.html.beads.SingleSelectionDropTargetBead.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class SingleSelectionDragSourceBead extends EventDispatcher implements IBead, IDragInitiator
	{
		public function SingleSelectionDragSourceBead()
		{
			super();
		}
		
		private var _strand:IStrand;
		private var _dragController:DragMouseController;
		
		private var _itemRendererParent:IParent;
		public function get itemRendererParent():IParent
		{
			if (_itemRendererParent == null) {
				_itemRendererParent = _strand.getBeadByType(IItemRendererParent) as IParent;
			}
			return _itemRendererParent;
		}
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			_dragController = new DragMouseController();
			_strand.addBead(_dragController);
			
			IEventDispatcher(_strand).addEventListener(DragEvent.DRAG_START, handleDragStart);
		}
		
		public function get strand():IStrand
		{
			return _strand;
		}
		
		private function handleDragStart(event:DragEvent):void
		{
			trace("SingleSelectionDragSourceBead received the DragStart");
			
			var downPoint:Point = new Point(event.clientX, event.clientY);//PointUtils.localToGlobal(new Point(event.clientX, event.clientY), _strand);
			trace("Dragging from this point: "+downPoint.x+", "+downPoint.y);
			trace("-- find the itemRenderer this object is over");
			
			if (itemRendererParent != null) {
				var n:Number = itemRendererParent.numElements;
				for (var i:int=0; i < n; i++) {
					var child:UIBase = itemRendererParent.getElementAt(i) as UIBase;
					if (child != null) {
						var childPoint:Point = PointUtils.localToGlobal(new Point(child.x,child.y), itemRendererParent);
						trace("-- child "+i+": "+childPoint.x+" - "+(childPoint.x+child.width)+" x "+childPoint.y+" - "+(childPoint.y+child.height));
						var rect:Rectangle = new Rectangle(childPoint.x, childPoint.y, child.width, child.height);
						if (rect.containsPoint(downPoint)) {							
							var ir:IItemRenderer = child as IItemRenderer;
							
							trace("-- dragging this child, " + i + ", at "+childPoint.x+", "+childPoint.y);
							
							//var dragImage:Label = new Label();
							//dragImage.text = ir.data.toString();
							var dragImage:UIBase = new Group();
							dragImage.className = "DragImage";
							dragImage.width = child.width;
							dragImage.height = child.height;
							var label:Label = new Label();
							label.text = ir.data.toString();
							dragImage.addElement(label);
							
							DragEvent.dragSource = {index:i, data:ir.data}; // needs to be the data from the child, but we'll get to that.
							DragEvent.dragInitiator = this;
							DragMouseController.dragImage = dragImage;
							break;
						}
					}
				}
			}
		}
		
		/* IDragInitiator */
		
		public function acceptingDrop(dropTarget:Object, type:String):void
		{
			trace("Accepting drop of type "+type);
		}
		
		public function acceptedDrop(dropTarget:Object, type:String):void
		{
			trace("Accepted drop of type "+type);
			var value:Object = DragEvent.dragSource;
			trace(" -- index: "+value.index+" of data: "+value.data);
		}
		
	}
}
