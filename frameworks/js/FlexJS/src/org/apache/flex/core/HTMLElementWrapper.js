/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org_apache_flex_core_HTMLElementWrapper');

goog.require('org_apache_flex_core_IBeadModel');
goog.require('org_apache_flex_core_IStrand');
goog.require('org_apache_flex_events_EventDispatcher');
goog.require('org_apache_flex_utils_Language');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 */
org_apache_flex_core_HTMLElementWrapper = function() {
  org_apache_flex_core_HTMLElementWrapper.base(this, 'constructor');
};
goog.inherits(org_apache_flex_core_HTMLElementWrapper,
    org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_HTMLElementWrapper.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'HTMLElementWrapper',
                qName: 'org_apache_flex_core_HTMLElementWrapper' }],
      interfaces: [org_apache_flex_core_IStrand] };


/**
 * @expose
 * @type {EventTarget}
 */
org_apache_flex_core_HTMLElementWrapper.prototype.element = null;


/**
 * @protected
 * @type {Array.<Object>}
 */
org_apache_flex_core_HTMLElementWrapper.prototype.strand = null;


/**
 * @expose
 * @param {Object} bead The new bead.
 */
org_apache_flex_core_HTMLElementWrapper.prototype.addBead = function(bead) {
  if (!this.strand) {
    this.strand = [];
  }

  this.strand.push(bead);

  if (org_apache_flex_utils_Language.is(bead, org_apache_flex_core_IBeadModel)) {
    this.model = bead;
  }

  bead.strand = this;
};


/**
 * @expose
 * @param {!Object} classOrInterface The requested bead type.
 * @return {Object} The bead.
 */
org_apache_flex_core_HTMLElementWrapper.prototype.getBeadByType =
    function(classOrInterface) {
  var bead, i, n;

  n = this.strand.length;
  for (i = 0; i < n; i++) {
    bead = this.strand[i];

    if (org_apache_flex_utils_Language.is(bead, classOrInterface)) {
      return bead;
    }
  }

  return null;
};


Object.defineProperties(org_apache_flex_core_HTMLElementWrapper.prototype, {
    'MXMLDescriptor': {
        get: function() {
            return null;
		}
	}
});


/**
 * @expose
 * @param {Object} bead The bead to remove.
 * @return {Object} The bead.
 */
org_apache_flex_core_HTMLElementWrapper.prototype.removeBead = function(bead) {
  var i, n, value;

  n = this.strand.length;
  for (i = 0; i < n; i++) {
    value = this.strand[i];

    if (bead === value) {
      this.strand.splice(i, 1);

      return bead;
    }
  }

  return null;
};